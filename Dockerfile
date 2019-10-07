FROM quay.io/perl/base-os:v3.10-1

ENV LAST_UPDATED 2019-10-06

ADD Makefile .

USER root
RUN apk add rsync
RUN make install && cpanm File::Rsync File::Rsync::Mirror::Recent XML::RSS Linux::Inotify2 && rm -fr ~/.cpanm
