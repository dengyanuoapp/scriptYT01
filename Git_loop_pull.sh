#!/bin/sh

while [ 1 = 1 ]
do
    echo ; echo 'befor pull ' ; echo
    df -h .
    du -sh .

    git pull

    echo ; echo 'end pull , sleep 30 minutes ' ; echo
    df -h .
    du -sh .

    rm -f `find -name "*.amr"`
    pwd

    sleep 30m

    sleep 5

done
