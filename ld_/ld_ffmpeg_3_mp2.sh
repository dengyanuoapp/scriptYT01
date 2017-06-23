#!/bin/sh

rr1=/home/rootX/rootY
[ -d ${rr1} ] || rr1=/home/bootH/rootX/rootY

rr2=${rr1}/lib
rr3=${rr1}/lib/ld-linux.so.2 

bb1=$1
bb2=xxx
if [ -n "${bb1}" ]
then
	bb2=$(echo ${bb1}|sed -e 's;\.m4a$;;g' -e 's;\.mp[234]$;;g' -e 's;\.webm$;;g' -e 's;\.opus$;;g' |tr -d '-' |tr -d '.' |tr -d '/' |tr -d '_')
    #bb2=$(echo ${bb2}|grep -o '..........$')
    #sed 's/.*\(...\)/\1/'
    bb2=$(echo __________________${bb2}|grep -o '.\{10\}$')
fi
date1=$(date +"%Y_%m%d__%H%M%P")
date1=$(date +"%y%m%d%H%M%P")
date1=$(date +"%y%m%d_%H%M")

rate=16k
freq=16000

rate=24k
freq=22050

echo   "LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -vn -i ${1} -ac 1 -maxrate ${rate} -ar ${freq} -f mp2 -ab ${rate} -y ${date1}_${bb2}.mp2"
        LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -vn -i ${1} -ac 1 -maxrate ${rate} -ar ${freq} -f mp2 -ab ${rate} -y ${date1}_${bb2}.mp2
