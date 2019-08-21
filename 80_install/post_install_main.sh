#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pushd /tmp
# git clone https://github.com/meganz/MEGAcmd.git
time git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git
time tar cf MEGAcmd.tar ./MEGAcmd
time pbzip2 -p2 --best MEGAcmd.tar
ls -lang
popd

time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/MEGAcmd.tar.bz2 \
    ${WEBDAV_URL}MEGAcmd.tar.bz2

echo ${start_date}
date
