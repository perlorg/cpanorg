
all: build

update: build

clean: buildclean

buildclean: rmclean build

rmclean:
	rm -fr html

build:
	@SRC=src ttree -f tt.rc



