FROM harbor.ntppool.org/perlorg/base-os:3.22.1-1

USER root
RUN apk add rsync perl-xml-rss perl-xml-parser

# for 'make install'
ADD Makefile /tmp/


RUN cd /tmp && make install \
  && cpanm File::Rsync File::Rsync::Mirror::Recent \
          Linux::Inotify2 Time::Progress \
  && rm -fr ~/.cpanm && rm /tmp/Makefile

RUN addgroup cpan && adduser -u 1000 -D -G cpan cpan
