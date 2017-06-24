#!/bin/sh

echo 

while [ 1 ]
do
	#echo 	"$(cat nohup.out |tail -n 1)"
    #   Duration: 00:47:52.33, start: 0.000000, bitrate: 126 kb/s
	echo -n	" $(cat nohup.out |grep bitrate=|tail -n 1|sed -e 's;[\r\n]; ;g' -e 's;^.*size=;size=;g') "
    echo -n	" $(cat nohup.out |grep Duration|tail -n 1|sed -e 's;^.*Duration: ;;g' -e 's;\..*$;;g' ) "
    echo -n	`cat nohup.out |grep Input\ |tail -n 1|sed -e "s;^[^']*';;g" -e 's;^[0-9_]*;;g' -e "s;'[^']*$;;g" -e "s;[ _\.\-];;g" `
	echo
    grep -q END1\  nohup.out && echo &&echo&&grep END1 nohup.out && date -d '+16 hour'    +%Y%m%d__%H%M%p && echo && exit 3
	sleep 5
done
