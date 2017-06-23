#!/bin/sh

rr1=/home/rootX/rootY
[ -d ${rr1} ] || rr1=/home/bootH/rootX/rootY

rr2=${rr1}/lib
rr3=${rr1}/lib/ld-linux.so.2 

echo   "LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -i ${1} -vn -ac 1 -maxrate 64k -ar 24k ${1}.aac"
        LD_LIBRARY_PATH=${rr2} nice -n 19 ffmpeg -i ${1} -vn -ac 1 -maxrate 64k -ar 24k ${1}.aac
