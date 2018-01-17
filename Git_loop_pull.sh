#!/bin/bash

while [ 1 = 1 ]
do
    echo ; echo 'befor pull ' ; echo
    df -h .
    du -sh .

    if [ -z "$1" ]
    then
        git pull
    else
        if echo ${1}|grep -q ':'
        then
            echo "https_proxy=${1}"
                  https_proxy=${1}       git pull
            echo "https_proxy=${1}"
        else
            echo "https_proxy=${1}:22224"
                  https_proxy=${1}:22224 git pull
            echo "https_proxy=${1}:22224"
        fi
    fi

    echo ; echo 'end pull , sleep 30 minutes :$( date ) ' ; echo
    df -h .
    du -sh .

    rm -f `find -name "*.amr"`
    pwd

    grep https:// .git/config
    sleep 30m
    grep https:// .git/config

    sleep 5

done
