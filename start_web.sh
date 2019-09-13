#!/bin/bash

set -x

export TZ=JST-9

export USER_AGENT=$(curl https://raw.githubusercontent.com/tshr20140816/heroku-mode-07/master/useragent.txt)
export WEB_CONCURRENCY=4

if [ ! -v BASIC_USER ]; then
  echo "Error : BASIC_USER not defined."
  exit
fi

if [ ! -v BASIC_PASSWORD ]; then
  echo "Error : BASIC_PASSWORD not defined."
  exit
fi

htpasswd -c -b .htpasswd ${BASIC_USER} ${BASIC_PASSWORD}

# gcc -c -Q -march=native --help=target
# grep -c -e processor /proc/cpuinfo
# cat /proc/cpuinfo | head -n $(($(cat /proc/cpuinfo | wc -l) / $(grep -c -e processor /proc/cpuinfo)))

# hostname -i

# printenv

pushd www
chmod +x curl
ldd curl
popd

# unlink /app/.apt/usr/lib/x86_64-linux-gnu/liblzo2.so
# cp liblzo2.so.2.0.0 /app/.apt/usr/lib/x86_64-linux-gnu/
# ln -s /app/.apt/usr/lib/x86_64-linux-gnu/liblzo2.so.2.0.0 /app/.apt/usr/lib/x86_64-linux-gnu/liblzo2.so
# ln -s /app/.apt/usr/lib/x86_64-linux-gnu/liblzo2.so.2.0.0 /app/.apt/usr/lib/x86_64-linux-gnu/liblzo2.so.2
# ls -lang /app/.apt/usr/lib/x86_64-linux-gnu/
# whereis pixz
# ldd /app/.apt/usr/bin/pixz
# pixz -V

vendor/bin/heroku-php-apache2 -C apache.conf www
# distccd –daemon –port ${PORT}
