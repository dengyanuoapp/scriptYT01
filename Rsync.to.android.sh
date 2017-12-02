#!/bin/bash

aaa1=192.168.197.49
aaa2=/sdcard/9/
[ -z "$1" ] || aaa1=$1

echo 
echo " to .... ${aaa1} ${aaa2} "

nice -n 19 \
    rsync -r -v -l -c \
    --delete --inplace --omit-dir-times --no-perms --size-only \
    -e "ssh -p 22225"  \
    ./  \
    aa@${aaa1}:{aaa2}
