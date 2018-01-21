#!/bin/bash

p01="vpn_j3_bw3t:20019"
p02="vpn_j3_bw3:20019"
p03="vpn_v22t:20022"
p04="vpn_v22:20022"


cat << EOF

Usage :
    $0 [1|2|3|4|PROXY]
    1       -> ${p01}
    2       -> ${p02}
    3       -> ${p03}
    4       -> ${p04}
    PROXY   -> PROXY???

EOF

pro01=
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
                pro01="${1}"
            else
                pro01="${1}:22224"
            fi
            ;;
    esac
fi

while [ 1 = 1 ]
do
    echo ; echo 'befor pull ' ; echo
    df -h .
    du -sh .

    echo    "https_proxy=${pro01}"
    echo    "https_proxy=${pro01}       git pull"
             https_proxy=${pro01}       git pull 
    echo    "https_proxy=${pro01}       git pull"
    echo    "https_proxy=${pro01}"

    echo ; echo "end pull , sleep 30 minutes :$( date ) " ; echo
    df -h .
    du -sh .

    rm -f `find -name "*.amr"`
    pwd

    grep https:// .git/config
    sleep 30m
    grep https:// .git/config

    sleep 5

done
