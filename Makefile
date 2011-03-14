
all: build

clean: buildclean

update: build
	rsync -av html/ ../CPAN/

buildclean: rmclean build

rmclean:
	rm -fr html

build:
	@SRC=src ttree -f tt.rc


install:
	cpanm Template Template::Plugin::JSON

