#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

pushd /tmp
# git clone https://github.com/meganz/MEGAcmd.git
time git clone --recursive --depth=1 --shallow-submodules https://github.com/meganz/MEGAcmd.git
ls -lang
popd

echo ${start_date}
date
