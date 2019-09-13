#!/bin/bash

set -x

date
start_date=$(date)

# git clone --depth 1 https://github.com/box/boxcli.git
# pushd boxcli
# npm i
# npm audit
# npm audit fix
# popd

time npm i npm-check-updates eslint

echo ${start_date}
date
