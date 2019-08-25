#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

nautilus --version

pushd /tmp
curl -O https://linux.dropbox.com/packages/dropbox.py
chmod +x dropbox.py
time timeout -sKILL 30 ./dropbox.py --version
popd

ls -lang /tmp/usr
ls -lang /tmp/usr/bin

echo ${start_date}
date
