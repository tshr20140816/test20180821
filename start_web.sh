#!/bin/bash

set -x

export TZ=JST-9

export USER_AGENT=$(curl https://raw.githubusercontent.com/tshr20140816/heroku-mode-07/master/useragent.txt)

if [ ! -v BASIC_USER ]; then
  echo "Error : BASIC_USER not defined."
  exit
fi

if [ ! -v BASIC_PASSWORD ]; then
  echo "Error : BASIC_PASSWORD not defined."
  exit
fi

htpasswd -c -b .htpasswd ${BASIC_USER} ${BASIC_PASSWORD}

gcc -c -Q -march=native --help=target
cat /proc/cpuinfo

vendor/bin/heroku-php-apache2 -C apache.conf www
