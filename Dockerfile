FROM golang:1.15.6-alpine3.12 as builder

LABEL maintainer="Takeru Sato <type.in.type@gmail.com>"

# ENV GO111MODULE           on
ENV GEOIP_UPDATE_VERSION  4.3.0
ENV SRC_DL_URL_PREF       https://github.com/maxmind/geoipupdate/archive
ENV SRC_PATH              /go/src/github.com/maxmind/geoipupdate

RUN mkdir -p /go/src/github.com/maxmind/
RUN apk add --update --no-cache curl gcc make libc-dev git
RUN curl -L "${SRC_DL_URL_PREF}/v${GEOIP_UPDATE_VERSION}.tar.gz" | tar -zxC /go/src/github.com/maxmind/
RUN mv "${SRC_PATH}-${GEOIP_UPDATE_VERSION}" /go/src/github.com/maxmind/geoipupdate
RUN cd "${SRC_PATH}" && make build/geoipupdate
RUN curl -L "https://github.com/gliderlabs/sigil/releases/download/v0.4.0/sigil_0.4.0_$(uname -sm|tr \  _).tgz" | tar -zxC /usr/local/bin

FROM alpine:3.12

ENV GEOIP_CONF_FILE /usr/local/etc/GeoIP.conf
ENV GEOIP_DB_DIR    /usr/share/GeoIP
ENV SCHEDULE        "55 20 * * *"

COPY GeoIP.conf.tmpl ${GEOIP_CONF_FILE}.tmpl
COPY run-geoipupdate /usr/local/bin/run-geoipupdate
COPY run /usr/local/bin/
COPY --from=builder /go/src/github.com/maxmind/geoipupdate/build/geoipupdate /usr/local/bin/
COPY --from=builder /usr/local/bin/sigil /usr/local/bin/

RUN apk add --update --no-cache ca-certificates

CMD /usr/local/bin/run
