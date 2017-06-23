#!/bin/sh

rr1=/home/rootX/rootY
[ -d ${rr1} ] || rr1=/home/bootH/rootX/rootY

rr2=${rr1}/lib
rr3=${rr1}/lib/ld-linux.so.2 

bb1="$1"
bb2=xxx
if [ -n "${bb1}" ]
then
	bb2=$(echo ${bb1}|sed -e 's;\.m4a$;;g' -e 's;\.mp[234]$;;g' -e 's;\.webm$;;g' -e 's;\.opus$;;g' |tr -d '-' |tr -d '.' |tr -d '/' |tr -d '_')
    #bb2=$(echo ${bb2}|grep -o '..........$')
    #sed 's/.*\(...\)/\1/'
    bb2=$(echo __________________${bb2}|grep -o '.\{10\}$')

    bb2=$(echo -n ${bb1}|sed -e 's;\.m4a$;;g' -e 's;\.mp[234]$;;g' -e 's;\.webm$;;g' -e 's;\.opus$;;g' -e 's;\r\n ;;g' -e 's;__*;_;g'|tr -d ' ')
fi

bb3="${bb2}.ogg"

if [ -f ${bb3} ]
then
    echo " file <${bb3}> exist. skip . exit. "
    exit
fi

echo " gen file <${bb3}> from <${1}>." 

rate=16k
freq=16000

rate=24k
freq=22050

rate=8k
freq=8000

rate=16k
freq=24000

echo   "LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -vn -i \"${1}\" -ac 1 -maxrate ${rate} -ar ${freq} -f opus -ab ${rate} -y \"${bb3}\""
        LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -vn -i  "${1}"  -ac 1 -maxrate ${rate} -ar ${freq} -f opus -ab ${rate} -y  "${bb3}"
