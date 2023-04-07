FROM harbor.ntppool.org/perlorg/base-os:3.17.3

USER root
RUN apk add rsync

# for 'make install'
ADD Makefile /tmp/

RUN cd /tmp && make install \
  && cpanm File::Rsync File::Rsync::Mirror::Recent \
          XML::RSS Linux::Inotify2 \
  && rm -fr ~/.cpanm && rm /tmp/Makefile

RUN addgroup cpan && adduser -u 1000 -D -G cpan cpan
