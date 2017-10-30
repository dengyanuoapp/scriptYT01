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
        echo "https_proxy=${1}:22224"
              https_proxy=${1}:22224 git pull
    fi

    echo ; echo 'end pull , sleep 30 minutes ' ; echo
    df -h .
    du -sh .

    rm -f `find -name "*.amr"`
    pwd

    sleep 30m

    sleep 5

done
