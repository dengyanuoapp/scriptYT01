#!/bin/sh

echo 
echo 
echo 
echo 

#cat  tmp3/nohup.out  |cut -c 1-150 |tail -n 10 
cat  tmp3/nohup.out  |tail -n 10 |sed -e 's;[\r\n]; ;g' -e 's;^.*size=;;g' 

for aa1 in tmp3/U* ; do

    echo
    ls -l ${aa1}/ |sed -e '1d' |head -n 3 
    echo "$(du -sh ${aa1}/) --- $(ls -l ${aa1}/ |wc)$(echo -n \ \  ; cd ${aa1}/ && ls yy* 2>/dev/null ) "
done 

echo
cat nohup.out |grep 'playlist Uploads from'
cat nohup.out |grep 'Downloading video '|grep ' of ' |tail -n 2
#cat nohup.out |grep ^size=|tail -n 1
cat nohup.out |grep ^size=|tail -n 1|sed -e 's;[\r\n]; ;g' -e 's;^.*size=;;g'

