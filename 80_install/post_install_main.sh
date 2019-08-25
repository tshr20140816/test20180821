#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

pushd /tmp
curl -o nautilus-dropbox.tar.bz2 https://linux.dropbox.com/packages/nautilus-dropbox-2019.02.14.tar.bz2
ls -lang

popd

echo ${start_date}
date
