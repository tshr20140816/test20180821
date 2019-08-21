#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pushd /tmp
time git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git

pushd MEGAcmd
time sh autogen.sh
time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no
popd

time tar cf MEGAcmd.tar ./MEGAcmd
time pbzip2 -p2 --best MEGAcmd.tar
ls -lang
popd

time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X DELETE ${WEBDAV_URL}MEGAcmd.tar.bz2
time curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} -X PUT \
    -H "Content-Type: application/x-compress" \
    --data-binary @/tmp/MEGAcmd.tar.bz2 \
    ${WEBDAV_URL}MEGAcmd.tar.bz2

echo ${start_date}
date
