#!/bin/bash

set -x

date
start_date=$(date)

export CFLAGS="-O2 -march=native -mtune=native -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fuse-ld=gold"

pushd /tmp
time git clone https://github.com/meganz/MEGAcmd.git
pushd MEGAcmd
time git submodule update --init --recursive
time sh autogen.sh
./configure --help
time ./configure --prefix=/tmp/usr --disable-curl-checks --enable-static=yes --enable-shared=no
time make -j2
popd
popd

echo ${start_date}
date
