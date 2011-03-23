
EXT_BAT=
EXT_EXE=
CPANM=cpanm$(EXT_BAT)
PERL=perl$(EXT_EXE)
TTREE=ttree$(EXT_BAT)
RSYNC=rsync$(EXT_EXE)

SRC=src

all: build

clean: buildclean

update: update-data build

update-master: update
	@$(RSYNC) --temp-dir=/cpan/tmp -a html/ ../CPAN/

buildclean: rmclean build

rmclean:
	$(PERL) -MExtUtils::Command -e "rm_rf" -- html

build: data/cpan-stats.json
	@$(TTREE) "--src=$(SRC)" -f tt.rc

data/cpan-stats.json: update-data

update-data:
	@$(PERL) ./bin/cpanorg_rss_fetch
	@$(PERL) ./bin/update_data

install:
	$(CPANM) Template JSON Template::Plugin::Comma Template::Plugin::JSON XML::RSS local::lib File::Slurp

