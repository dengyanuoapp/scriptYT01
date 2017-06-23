#!/bin/sh

rr1=/home/rootX/rootY
[ -d ${rr1} ] || rr1=/home/bootH/rootX/rootY

rr2=${rr1}/lib
rr3=${rr1}/lib/ld-linux.so.2 

bb1="$1"
bb3="${bb1}.ogg"

if [ -f ${bb3} ]
then
    echo " file <${bb3}> exist. skip . exit. "
    exit
fi

echo " gen file <${bb3}> from <${bb1}>." 

rate=16k
freq=16000

rate=24k
freq=22050

rate=8k
freq=8000

rate=16k
freq=24000

echo   "LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -vn -i \"${bb1}\" -ac 1 -maxrate ${rate} -ar ${freq} -f opus -ab ${rate} -y \"${bb3}\""
        LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -vn -i  "${bb1}"  -ac 1 -maxrate ${rate} -ar ${freq} -f opus -ab ${rate} -y  "${bb3}"
