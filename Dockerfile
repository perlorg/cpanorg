FROM harbor.ntppool.org/perlorg/base-os:3.17.3

ADD Makefile .

USER root
RUN apk add rsync
RUN make install \
  && cpanm File::Rsync File::Rsync::Mirror::Recent \
          XML::RSS Linux::Inotify2 \
  && rm -fr ~/.cpanm
