#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pwd
cd /tmp

curl -u ${WEBDAV_USER}:${WEBDAV_PASSWORD} ${WEBDAV_URL} -O

ls -lang

# unzip -q ccache_cache.zip
tar xvf ccache_cache.zip

ls -lang

tar Jcvf ccache_cache.tar.xz ./ccache

ls -lang

rm -rf ./ccache

ls -lang

tar xf ccache_cache.tar.xz

ls -lang ccache

# find ccache
