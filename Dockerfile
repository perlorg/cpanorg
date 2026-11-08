FROM harbor.ntppool.org/dev/ticker:0.2.3 AS ticker

FROM harbor.ntppool.org/perlorg/base-os:3.24.4

USER root
RUN apk add \
    findutils \
    gzip \
    perl-xml-parser \
    perl-xml-rss \
    rcs \
    rsync # no slash on last item

# for 'make install'
ADD Makefile /tmp/

COPY --from=ticker /app/ticker /usr/bin/ticker

RUN cd /tmp && make install \
  && cpanm File::Rsync \
          Linux::Inotify2 Time::Progress JSON Data::Serializer JSON::XS \
          https://github.com/abh/rersyncrecent.git@fix/rmirror-interval-propagation \
  && rm -fr ~/.cpanm && rm /tmp/Makefile

RUN addgroup cpan && adduser -u 1000 -D -G cpan cpan
