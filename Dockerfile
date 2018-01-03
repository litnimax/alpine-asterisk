# vim:set ft=dockerfile:
FROM alpine:edge

ENV maintainer litnimaxster@gmail.com

RUN	apk update && apk upgrade

RUN apk add libltdl unixodbc

RUN apk add sudo findutils less curl sngrep ngrep tcpdump libcap libedit libxml2 jansson sqlite sqlite-libs libuuid

RUN rm -rf /usr/lib/asterisk/modules/* &&  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# grab dockerize for generation of the configuration file and wait on postgres
RUN curl https://github.com/jwilder/dockerize/releases/download/v0.6.0/dockerize-alpine-linux-amd64-v0.6.0.tar.gz -L | tar xz -C /usr/local/bin
# Asterisk conf templates
COPY ./etc/asterisk/*tmpl /etc/asterisk/
COPY ./etc/*tmpl /etc/

# Build Asterisk
ADD ./packages/ /packages/
RUN cd /packages && apk add --allow-untrusted asterisk-15.1.5-r0.apk asterisk-odbc-15.1.5-r0.apk asterisk-sample-config-15.1.5-r0.apk asterisk-sounds-en-15.1.5-r0.apk asterisk-sounds-moh-15.1.5-r0.apk asterisk-srtp-15.1.5-r0.apk

# start asterisk so it creates missing folders and initializes astdb
RUN asterisk && sleep 5

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 5060/udp


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/asterisk", "-vvvdddfn", "-T", "-U", "root", "-p"]
