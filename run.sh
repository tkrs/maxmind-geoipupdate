#!/bin/sh

# Render the template
mkdir -p ${GEOIP_DB_DIR}
cat ${GEOIP_CONF_FILE}.tmpl | sigil -p > ${GEOIP_CONF_FILE}

geoipupdate -v && node /server.js
