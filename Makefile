
EXT_BAT=
EXT_EXE=
CPANM=cpanm$(EXT_BAT)
PERL=perl$(EXT_EXE)
TTREE=ttree$(EXT_BAT)
RSYNC=rsync$(EXT_EXE)

SRC=src
WORKDIR?=.
DEST=$(WORKDIR)/html
DATA=$(WORKDIR)/data
PRIMARY?=../CPAN
RSYNC_TEMP_DIR?=$(WORKDIR)/tmp

all: build

clean: buildclean

update: update-data build

update-primary: update
	@mkdir -p $(RSYNC_TEMP_DIR)
	@$(RSYNC) --temp-dir=$(RSYNC_TEMP_DIR) -a $(DEST)/ $(PRIMARY)/

buildclean: rmclean build

rmclean:
	$(PERL) -MExtUtils::Command -e "rm_rf" -- $(DEST)

build: $(DATA)/cpan-stats.json
	@$(TTREE) "--src=$(SRC)" "--dest=$(DEST)" "--lib=$(DATA)" -f tt.rc

$(DATA)/cpan-stats.json: update-data

update-data:
	@DATA=$(DATA) $(PERL) ./bin/cpanorg_rss_fetch
	@DATA=$(DATA) $(PERL) ./bin/update_data

update-daily:
	@DATA=$(DATA) $(PERL) ./bin/cpanorg_perl_releases

install:
	$(CPANM) Template JSON Template::Plugin::Comma Template::Plugin::JSON XML::RSS local::lib File::Slurp

update-docker:
	docker run -w /cpan -v $(PWD):/cpan --rm -ti harbor.ntppool.org/perlorg/cpanorg:latest make update
