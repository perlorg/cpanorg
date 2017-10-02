FROM quay.io/perl/base-os:v3.0

USER root
RUN apk add rsync
RUN cpanm File::Rsync File::Rsync::Mirror::Recent XML::RSS Linux::Inotify2; rm -fr ~/.cpanm
ADD rrr-server-fsck.patch /tmp/
RUN cat /tmp/rrr-server-fsck.patch | patch -p3 /usr/local/bin/rrr-server

