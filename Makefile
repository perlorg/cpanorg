
all: build

clean: buildclean

update: update-data build

update-master: update
	rsync -av html/ ../CPAN/

buildclean: rmclean build

rmclean:
	rm -fr html

build:
	@SRC=src ttree -f tt.rc

update-data:
	@./bin/cpanorg_rss_fetch

install:
	cpanm Template JSON Template::Plugin::JSON \
	XML::RSS local::lib File::Slurp

