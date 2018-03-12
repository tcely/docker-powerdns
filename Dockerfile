FROM alpine:edge

ENV REFRESHED_AT="2018-03-08" \
    POWERDNS_VERSION="4.1.1" \
    MYSQL_AUTOCONF="true" \
    MYSQL_HOST="mysql" \
    MYSQL_PORT="3306" \
    MYSQL_USER="root" \
    MYSQL_PASS="root" \
    MYSQL_DB="pdns"

RUN apk --update add \
      pdns-backend-bind pdns-backend-mysql pdns-backend-pgsql \
      pdns-backend-lua pdns-backend-pipe pdns-backend-sqlite3 \
      pdns-backend-random pdns-backend-remote \
      pdns-tools && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

ADD schema.sql pdns.conf /etc/pdns/
ADD entrypoint.sh /

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/entrypoint.sh"]
