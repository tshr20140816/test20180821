#!/bin/bash

set -x

date
start_date=$(date)

cp Stirling.zip /tmp/Stirling.zip
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT -H "Content-Type: application/x-compress" --data-binary @/tmp/Stirling.zip ${WEBDAV_URL}

echo ${start_date}
date
