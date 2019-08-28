#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

mkdir dropbox
pushd dropbox
curl -O https://linux.dropbox.com/packages/dropbox.py
chmod +x dropbox.py
time timeout -sKILL 30 ./dropbox.py help
time timeout -sKILL 30 ./dropbox.py version
time timeout -sKILL 30 echo y|./dropbox.py update
# ./dropbox.py start
# ./dropbox.py lansync n
# ./dropbox.py status
popd

echo ${start_date}
date
