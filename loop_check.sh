#!/bin/sh

echo 

kw1=直播
kw2=，
kw3=？
kw4=（
kw5=《
kw6=》
kw7=）


while [ 1 ]
do
	#echo 	"$(cat nohup.out |tail -n 1)"
    #   Duration: 00:47:52.33, start: 0.000000, bitrate: 126 kb/s
	echo -n	" $(cat nohup.out |grep bitrate=|tail -n 1|sed -e 's;[\r\n]; ;g' -e 's;^.*size=;size=;g') "
    echo -n	" $(cat nohup.out |grep Duration|tail -n 1|sed -e 's;^.*Duration: ;;g' -e 's;\..*$;;g' ) "
    echo -n	`cat nohup.out |grep Input\ |tail -n 1|sed \
        -e "s;${kw1};_;g"   \
        -e "s;${kw2};_;g"   \
        -e "s;${kw3};_;g"   \
        -e "s;${kw4};_;g"   \
        -e "s;${kw5};_;g"   \
        -e "s;${kw6};_;g"   \
        -e "s;${kw7};_;g"   \
        -e "s;^[^']*';;g" -e 's;^[0-9_]*;;g' -e "s;'[^']*$;;g" -e "s;[ _\.\-];;g" `
	echo
    grep -q 1END1\  nohup.out && echo &&echo&&grep END1 nohup.out && date -d '+16 hour'    +%Y%m%d__%H%M%p && echo && exit 3
	sleep 5
done
