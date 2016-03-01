FROM gliderlabs/alpine:3.3

MAINTAINER Takeru Sato <midium.size@gmail.com>

ENV NODE_VERSION=v5.7.0 NPM_VERSION=3
ENV CONFIG_FLAGS="--fully-static --without-npm"

ENV GEOIP_UPDATE_VERSION             2.2.2
ENV SRC_DL_URL_PREF     https://github.com/maxmind/geoipupdate/archive
ENV GEOIP_CONF_FILE /usr/etc/GeoIP.conf
ENV GEOIP_DB_DIR        /usr/share/GeoIP

COPY GeoIP.conf.tmpl ${GEOIP_CONF_FILE}.tmpl
COPY run.sh /bin/
COPY server.js /

RUN BUILD_DEPS='gcc make libc-dev libtool automake autoconf g++ binutils-gold python linux-headers paxctl libgcc libstdc++' \
 && apk-install curl-dev ${BUILD_DEPS} \
 && curl -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz | tar -xz \
 && cd node-${NODE_VERSION} \
 && ./configure --prefix=/usr ${CONFIG_FLAGS} \
 && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && make install \
 && paxctl -cm /usr/bin/node \
 && cd / \
 && if [ -x /usr/bin/npm ]; then \
      npm i -g npm@${NPM_VERSION} && \
      find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
    fi \
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
 && rm -rf /etc/ssl /node-${NODE_VERSION} /usr/include /usr/share/man /root/.npm /root/.node-gyp \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html \
 && chmod 755 /bin/run.sh

CMD exec /bin/run.sh
