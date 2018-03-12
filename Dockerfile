FROM alpine:edge

COPY schema.sql pdns.conf /etc/pdns/
COPY entrypoint.sh /

EXPOSE 53/tcp 53/udp

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

ENTRYPOINT ["/entrypoint.sh"]
