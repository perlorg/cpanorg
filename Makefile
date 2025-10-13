
EXT_BAT=
EXT_EXE=
CPANM=cpanm$(EXT_BAT)
PERL=perl$(EXT_EXE)
TTREE=ttree$(EXT_BAT)
RSYNC=rsync$(EXT_EXE)

SRC=src
DEST?=html
PRIMARY?=../CPAN

all: build

clean: buildclean

update: update-data build

update-primary: update
	@$(RSYNC) --temp-dir=/cpan/tmp -a $(DEST)/ $(PRIMARY)/

buildclean: rmclean build

rmclean:
	$(PERL) -MExtUtils::Command -e "rm_rf" -- $(DEST)

build: data/cpan-stats.json
	@$(TTREE) "--src=$(SRC)" "--dest=$(DEST)" -f tt.rc

data/cpan-stats.json: update-data

update-data:
	@$(PERL) ./bin/cpanorg_rss_fetch
	@$(PERL) ./bin/update_data

update-daily:
	@$(PERL) ./bin/cpanorg_perl_releases

install:
	$(CPANM) Template JSON Template::Plugin::Comma Template::Plugin::JSON XML::RSS local::lib File::Slurp

update-docker:
	docker run -w /cpan -v $(PWD):/cpan --rm -ti harbor.ntppool.org/perlorg/cpanorg:latest make update
