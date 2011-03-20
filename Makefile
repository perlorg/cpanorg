
all: build

clean: buildclean

update: update-data build

update-master: update
	rsync --temp-dir=/cpan/tmp -av html/ ../CPAN/

buildclean: rmclean build

rmclean:
	rm -fr html

build: data/cpan-stats.json
	@SRC=src ttree -f tt.rc

data/cpan-stats.json: update-data

update-data:
	@./bin/cpanorg_rss_fetch
	@./bin/update_data

install:
	cpanm Template JSON Template::Plugin::Comma  Template::Plugin::JSON \
	XML::RSS local::lib File::Slurp

