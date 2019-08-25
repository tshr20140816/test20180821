#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

nautilus --version

pushd /tmp
curl -o nautilus-dropbox.tar.bz2 https://linux.dropbox.com/packages/nautilus-dropbox-2019.02.14.tar.bz2
mkdir nautilus-dropbox
tar xf nautilus-dropbox.tar.bz2 -C nautilus-dropbox --strip-components 1
ls -lang
pushd nautilus-dropbox
./configure --help
./configure --prefix=/tmp/usr --with-gnu-ld
time make
time make install
popd
popd

ls -lang /tmp/usr
ls -lang /tmp/usr/bin

echo ${start_date}
date
