# vim:set ft=dockerfile:
FROM alpine:edge

ENV maintainer litnimaxster@gmail.com

RUN	apk update && apk upgrade

RUN apk add libltdl unixodbc

RUN apk add sudo findutils less curl sngrep ngrep tcpdump

RUN rm -rf /usr/lib/asterisk/modules/* &&  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Prepare packager account for building Asterisk
RUN     mkdir -p /var/cache/distfiles && \
        adduser -D packager && \
        addgroup packager abuild && \
        chgrp abuild /var/cache/distfiles && \
        chmod g+w /var/cache/distfiles && \
        echo "packager    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

VOLUME ["/work"]

# TODO: move this to dependencies of building Asterisk
RUN apk update && apk add alpine-sdk libtool bsd-compat-headers ncurses-dev popt-dev newt-dev zlib-dev libedit-dev libressl-dev libxml2-dev \
    lua-dev libcap-dev jansson-dev util-linux-dev libresample  sqlite-dev unixodbc-dev libsrtp-dev

# grab dockerize for generation of the configuration file and wait on postgres
RUN curl https://github.com/jwilder/dockerize/releases/download/v0.6.0/dockerize-alpine-linux-amd64-v0.6.0.tar.gz -L | tar xz -C /usr/local/bin
# Asterisk conf templates
COPY ./etc/asterisk/*tmpl /etc/asterisk/

# Build Asterisk
ADD ./aports/asterisk/ /home/packager/asterisk/
RUN ls /home/packager/asterisk/ && su - packager -c /home/packager/asterisk/build.sh

# start asterisk so it creates missing folders and initializes astdb
RUN asterisk && sleep 5

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 5060/udp


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddfn", "-T", "-U", "root", "-p"]
