FROM alpine
MAINTAINER Christoph Wiechert <wio@psitrax.de>

ENV REFRESHED_AT="2017-05-17" \
    POWERDNS_VERSION=4.0.4 \
    MYSQL_AUTOCONF=true \
    MYSQL_HOST="mysql" \
    MYSQL_PORT="3306" \
    MYSQL_USER="root" \
    MYSQL_PASS="root" \
    MYSQL_DB="pdns"

RUN apk --update add mysql-client mariadb-client-libs mariadb-libs libpq postgresql-libs sqlite-libs libressl libstdc++ libgcc lua libsodium && \
    apk add --virtual build-deps \
      g++ make mariadb-dev postgresql-dev sqlite-dev lua-dev libressl-dev curl boost-dev libsodium-dev file && \
    curl -sSL https://downloads.powerdns.com/releases/pdns-$POWERDNS_VERSION.tar.bz2 | tar xj -C /tmp && \
    cd /tmp/pdns-$POWERDNS_VERSION && \
    ./configure --prefix="" --exec-prefix=/usr --sysconfdir=/etc/pdns \
      --enable-libsodium --enable-tools --with-sqlite3 \
      --with-modules="bind gmysql gpgsql gsqlite3" --with-dynmodules="pipe random lua remote" && \
    make -j "$(awk '/^processor\t/ {CPUS=$NF} END {print ++CPUS}' /proc/cpuinfo)" && \
    make install-strip && cd / && \
    mkdir -p /etc/pdns/conf.d && \
    addgroup -S pdns 2>/dev/null && \
    adduser -S -D -H -h /var/empty -s /bin/false -G pdns -g pdns pdns 2>/dev/null && \
    apk del --purge build-deps && \
    rm -rf /tmp/pdns-$POWERDNS_VERSION /var/cache/apk/*

ADD schema.sql pdns.conf /etc/pdns/
ADD entrypoint.sh /

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["/entrypoint.sh"]
