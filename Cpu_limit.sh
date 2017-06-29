#!/bin/sh

if [ ! -f /proc/cpuinfo ] 
then
    echo 
    echo "cpuinfo do NOT exist. exit.: <$*>" 
    echo 
    echo 
    exit 33 
fi

if [ "${USER}" = 'dyn' ] 
then
    echo 
    echo "yould should run by dyn only.<$*>"
    echo 
    exit 44 
fi

if [ -z "$1" ] 
then
    echo 
    echo "why $1 NULL ?<$*>"
    echo 
    exit 44 
fi

echo "== $0 , $* : begin : `date`"
echo " $0 --- cpulimit -l 47  -z -p $1 "
cpulimit -l 47  -z -p $1

echo "== $0 , $* : end : `date`"
