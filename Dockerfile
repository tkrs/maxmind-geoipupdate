FROM gliderlabs/alpine:3.3

MAINTAINER Takeru Sato <midium.size@gmail.com>

ENV GEOIP_UPDATE_VERSION             2.2.2
ENV SRC_DL_URL_PREF     https://github.com/maxmind/geoipupdate/archive
ENV GEOIP_CONF_FILE /usr/etc/GeoIP.conf
ENV GEOIP_DB_DIR        /usr/share/GeoIP

COPY GeoIP.conf.tmpl ${GEOIP_CONF_FILE}.tmpl
COPY run.sh /bin/

RUN BUILD_DEPS='gcc make libc-dev libtool automake autoconf' \
 && apk-install curl-dev ${BUILD_DEPS} \
 && curl -k https://dl.gliderlabs.com/sigil/latest/$(uname -sm|tr \  _).tgz | tar -zxC /usr/local/bin \
 && curl -L -o /tmp/geoipupdate-${GEOIP_UPDATE_VERSION}.tar.gz ${SRC_DL_URL_PREF}/v${GEOIP_UPDATE_VERSION}.tar.gz \
 && cd /tmp \
 && tar zxvf geoipupdate-${GEOIP_UPDATE_VERSION}.tar.gz \
 && cd /tmp/geoipupdate-${GEOIP_UPDATE_VERSION} \
 && ./bootstrap \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && cd \
 && apk del --purge ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/geoipupdate-* \
 && chmod 755 /bin/run.sh

CMD exec /bin/run.sh
