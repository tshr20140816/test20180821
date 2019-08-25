#!/bin/bash

set -x

date
start_date=$(date)

git clone --depth 1 https://github.com/box/boxcli.git
pushd boxcli
npm i
popd

echo ${start_date}
date
