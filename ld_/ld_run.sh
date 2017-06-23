#!/bin/sh

rr1=/home/rootX/rootY
[ -d ${rr1} ] || rr1=/home/bootH/rootX/rootY

rr2=${rr1}/lib
rr3=${rr1}/lib/ld-linux.so.2 

echo   "LD_LIBRARY_PATH=${rr2} nice -n 18 $*"
        LD_LIBRARY_PATH=${rr2} nice -n 18 $*
