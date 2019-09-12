#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

cp /lib/x86_64-linux-gnu/liblzo2.so.2.0.0 ./

ls -lang

# pbzip2 --help
# megatools --version

cat << '__HEREDOC__' >jobs.txt
curl -sS -O https://oscdl.ipa.go.jp/IPAexfont/ipaexg00401.zip
curl -sS -L -o /tmp/migu-1m.zip "https://ja.osdn.net/frs/redir.php?m=iij&f=mix-mplus-ipa/63545/migu-1m-20150712.zip"
curl -sS -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcs.phar
curl -sS -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcbf.phar
__HEREDOC__

# time cat jobs.txt | parallel -j4 --joblog /tmp/joblog.txt 2>&1

cat /tmp/joblog.txt

ls -lang
pushd /tmp
time unzip migu-1m.zip
ls -lang migu-1m-20150712
popd
ls -lang

echo ${start_date}
date
