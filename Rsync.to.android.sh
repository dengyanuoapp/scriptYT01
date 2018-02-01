#!/bin/bash

aaa1=192.168.197.49
aaa2=/sdcard/9/
[ -z "$1" ] || aaa1=$1

nc01=br0
nc02=/sys/class/net/${nc01}/address
if [ ! -f ${nc02} ]
then
    nc01=eth0
    nc02=/sys/class/net/${nc01}/address
fi

if [ ! -f ${nc02} ]
then
    nc01=$(ls /sys/class/net/ |grep -v ^lo$ |grep -v ^tun |grep -v ^wlan |grep -v ^tap |grep -v ^br|head -n 1)
    nc02=/sys/class/net/${nc01}/address
fi

echo "--->> ${nc02} <<--"
if [ ! -f ${nc02} ]
then
    echo
    echo "why eth0 don't exist ? exit"
    echo
    exit
fi

rrr1=$( ip a show br0|grep inet |head -n 1|awk '{print $2}'|sed -e 's;\.[0-9]\+/[0-9]\+$;;g' )

p01=${rrr1}.51

cat << EOF

Usage :
    $0 [1|2|3|4|DST]
    1       -> ${p01}
    DST   -> DST???

EOF

pro01=${p01}
if [ -n "$1" ]
then
    case $1 in
        h|-h|help|-help)
            exit
            ;;
        1)
            pro01=${p01}
            ;;
        2)
            pro01=${p02}
            ;;
        *)
            if echo ${1}|grep -q ':'
            then
                pro01="${rrr1}.${1}"
                pro02=22225
            else
                pro01="${rrr1}.${1}"
                pro02=22225
            fi
            ;;
    esac
fi


echo 
echo " to .... ${aaa1} ${aaa2} "
echo " you can use the parameter 1 as the dst ip"

echo '\
    nice -n 19 \
    rsync -r -v -l -c \
    --delete --inplace --omit-dir-times --no-perms --size-only \
    -e "ssh -p '${pro02}'"  \
    ./  \
    'aa@${pro01}:${aaa2} 

    nice -n 19 \
    rsync -r -v -l -c \
    --delete --inplace --omit-dir-times --no-perms --size-only \
    -e "ssh -p ${pro02}"  \
    ./  \
    aa@${pro01}:${aaa2}
