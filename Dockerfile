FROM harbor.ntppool.org/perlorg/base-os:3.14.1

ENV LAST_UPDATED 2021-08-30

ADD Makefile .

USER root
RUN apk add rsync
RUN make install \
  && cpanm File::Rsync File::Rsync::Mirror::Recent \
          XML::RSS Linux::Inotify2 \
  && rm -fr ~/.cpanm
