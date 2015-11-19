FROM gliderlabs/alpine:3.2

MAINTAINER Takeru Sato <midium.size@gmail.com>

ENV VERSION             2.2.1
ENV SRC_DL_URL_PREF     https://github.com/maxmind/geoipupdate/archive
ENV GEOIP_CONF_FILE     /usr/etc/GeoIP.conf
ENV GEOIP_DB_DIR        /usr/share/GeoIP

RUN apk --update add gcc make libc-dev libtool curl-dev automake autoconf \
 && mkdir -p ${GEOIP_DB_DIR} \
 && curl -L -o /tmp/geoipupdate-${VERSION}.tar.gz ${SRC_DL_URL_PREF}/v${VERSION}.tar.gz \
 && cd /tmp \
 && tar zxvf geoipupdate-${VERSION}.tar.gz \
 && cd /tmp/geoipupdate-${VERSION} \
 && ./bootstrap \
 && ./configure --prefix=/usr \
 && make \
 && make install

ADD GeoIP.conf ${GEOIP_CONF_FILE}

CMD ["geoipupdate", "-v"]
