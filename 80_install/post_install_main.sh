#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pwd
cd /tmp

curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O

ls -lang

unzip -q ccache_cache.zip

ls -lang

time tar Jcf ccache_cache.tar.xz ./ccache
time zip -9qr ccache_cache.zip ./ccache

ls -lang

rm -rf ./ccache

ls -lang

tar xf ccache_cache.tar.xz

ls -lang ccache

# find ccache
