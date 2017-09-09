#!/bin/sh

[ -n "$1" ] || exit
[ -f "$1" ] || exit

cat $1 > /tmp/i1.txt 

cat /tmp/i1.txt | \
    iconv -f cp936 -t utf8 -c \
    > $1
