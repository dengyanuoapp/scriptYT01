#!/bin/sh

if [ ! -f /proc/cpuinfo ] 
then
    echo 
    echo "cpuinfo do NOT exist. exit.: <$*>" 
    echo 
    echo 
    exit 33 
fi

if [ "${USER}" != 'dyn' ] 
then
    echo 
    echo "yould should run by dyn only.<$*>"
    echo 
    exit 44 
fi

pid1=''

if [ -z "$1" ] 
then
    echo 
    echo "why 1 : $1 NULL ?<$*>"
    if    [ -f rootY/pid_now_ff.txt ] ; then
        pid1=`cat rootY/pid_now_ff.txt`
    elif  [ -f rootY/tmp/pid_now_ff.txt ] ; then
        pid1=`cat rootY/tmp/pid_now_ff.txt`
    fi
else
    pid1=$1
fi

if [ -z "${pid1}" ] 
then
    echo 
    echo "why pid1 : $1 NULL ?<$*>"
    exit 44 
fi

## 47 will active the foce drop down
#pC=32
pC=24
#pC=47
echo "== $0 , $* : begin : `date`"
echo " $0 --- cpulimit -l ${pC}  -z -p ${pid1} "
cpulimit -l ${pC}  -z -p ${pid1}

ps auxf |grep -v ' grep ' |grep ${pid1}

echo "== $0 , $* : end : `date`"
