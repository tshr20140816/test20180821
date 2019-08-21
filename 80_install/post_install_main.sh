#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

cd /tmp

time git clone --depth=1 https://github.com/ccache/ccache.git

cd ccache
time sh autogen.sh
./configure --help
time ./configure --prefix=/tmp/usr

echo ${start_date}
date
