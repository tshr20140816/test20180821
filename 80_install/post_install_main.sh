#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

cat << '__HEREDOC__' >jobs.txt
curl -v -O https://oscdl.ipa.go.jp/IPAexfont/ipaexg00401.zip
curl -v -L -o migu-1m.zip "https://ja.osdn.net/frs/redir.php?m=iij&f=mix-mplus-ipa/63545/migu-1m-20150712.zip"
curl -v -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcs.phar
curl -v -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcbf.phar
__HEREDOC__

time cat jobs.txt | parallel -j4 --joblog /tmp/joblog.txt 2>&1

# time curl -v -L -o migu-1m-20150712.zip "https://ja.osdn.net/frs/redir.php?m=iij&f=mix-mplus-ipa/63545/migu-1m-20150712.zip"

# time curl -sS -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcs.phar \
#               -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcbf.phar \
#               -O https://oscdl.ipa.go.jp/IPAexfont/ipaexg00401.zip \
#               -L -o migu-1m.zip "https://ja.osdn.net/frs/redir.php?m=iij&f=mix-mplus-ipa/63545/migu-1m-20150712.zip"

cat /tmp/joblog.txt

ls -lang
time unzip migu-1m.zip
ls -lang

echo ${start_date}
date
