#!/bin/bash

set -x

date
start_date=$(date)

chmod 777 start_web.sh

# pbzip2 --help
# megatools --version

cat << '__HEREDOC__' | xargs -L1 -P 2 -t -I{}
curl -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcs.phar
curl -O https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.2/phpcbf.phar
__HEREDOC__

ls -lang

echo ${start_date}
date
