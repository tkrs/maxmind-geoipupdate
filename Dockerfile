FROM gliderlabs/alpine:3.2

MAINTAINER Takeru Sato <midium.size@gmail.com>

ENV VERSION         2.2.1
ENV GEO_DL_URL      http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
ENV SRC_DL_URL_PREF https://github.com/maxmind/geoipupdate/archive
ENV CONF_FILE       /usr/etc/GeoIP.conf
ENV DEST_DIR        /usr/share/GeoIP

RUN apk --update add gcc make libc-dev libtool curl-dev automake autoconf \
 && mkdir -p ${DEST_DIR} \
 && curl -o /tmp/GeoLite2-City.mmdb.gz ${GEO_DL_URL} \
 && curl -L -o /tmp/geoipupdate-${VERSION}.tar.gz ${SRC_DL_URL_PREF}/v${VERSION}.tar.gz \
 && gunzip -c /tmp/GeoLite2-City.mmdb.gz > ${DEST_DIR}/GeoLite2-City.mmdb \
 && cd /tmp \
 && tar zxvf geoipupdate-${VERSION}.tar.gz \
 && cd /tmp/geoipupdate-${VERSION} \
 && ./bootstrap \
 && ./configure --prefix=/usr \
 && make \
 && make install

ADD GeoIP.conf ${CONF_FILE}

VOLUME ${DEST_DIR}

CMD ["geoipupdate", "v"]
