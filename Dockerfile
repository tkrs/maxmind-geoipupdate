FROM gliderlabs/alpine:3.2

MAINTAINER Takeru Sato <midium.size@gmail.com>

ENV VERSION             2.2.1
ENV SRC_DL_URL_PREF     https://github.com/maxmind/geoipupdate/archive
ENV GEOIP_CONF_FILE     /usr/etc/GeoIP.conf
ENV GEOIP_DB_DIR        /usr/share/GeoIP

RUN BUILD_DEPS='gcc make libc-dev libtool automake autoconf' \
 && apk-install curl-dev ${BUILD_DEPS} \
 && mkdir -p ${GEOIP_DB_DIR} \
 && curl -L -o /tmp/geoipupdate-${VERSION}.tar.gz ${SRC_DL_URL_PREF}/v${VERSION}.tar.gz \
 && cd /tmp \
 && tar zxvf geoipupdate-${VERSION}.tar.gz \
 && cd /tmp/geoipupdate-${VERSION} \
 && ./bootstrap \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && cd \
 && apk del --purge ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/geoipupdate-*

COPY GeoIP.conf ${GEOIP_CONF_FILE}

CMD ["geoipupdate", "-v"]
