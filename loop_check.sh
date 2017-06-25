#!/bin/sh

echo 

kw1=直播
kw2=，
kw3=？
kw4=（
kw5=《
kw6=》
kw7=）
kw8=：


while [ 1 ]
do
	#echo 	"$(cat Loop.log.txt |tail -n 1)"
    #   Duration: 00:47:52.33, start: 0.000000, bitrate: 126 kb/s
	echo -n	" $(tail -n 50  Loop.log.txt |grep bitrate=|tail -n 1|sed -e 's;[\r\n\t]; ;g' -e 's;^.*size=;size=;g' -e 's; \+; ;g')"
    echo -n	" $(tail -n 50  Loop.log.txt |grep Duration|tail -n 1|sed -e 's;^.*Duration: ;;g' -e 's;\..*$;;g'  -e 's; \+; ;g') "
    echo -n	`cat Loop.log.txt |grep Input\ |tail -n 1|sed \
        -e "s;${kw1};_;g"   \
        -e "s;${kw2};_;g"   \
        -e "s;${kw3};_;g"   \
        -e "s;${kw4};_;g"   \
        -e "s;${kw5};_;g"   \
        -e "s;${kw6};_;g"   \
        -e "s;${kw7};_;g"   \
        -e "s;${kw8};_;g"   \
        -e "s;^[^']*';;g" -e 's;^[0-9_]*;;g' -e "s;'[^']*$;;g" -e "s;[ _\.\-];;g" `
	echo

    #cat Loop.log.txt | tac | sed '/^Input/,$ d' | grep -q 'need to limit cpu , sleep' && (
    tail -n 3 Loop.log.txt | grep -q 'need to limit cpu , sleep' && (
            #line01="`cat Loop.log.txt |sed -e '1,/Input/ d' |grep 'need to limit cpu , sleep' |tail -n 1`"
            #line01="`cat Loop.log.txt | tac | sed '/^Input/,$ d' |grep 'need to limit cpu , sleep' |tail -n 1`"
            line01="`tail -n 3 Loop.log.txt |grep 'need to limit cpu , sleep' |tail -n 1`"
            now01=$(date +%s)
            last01=$(echo ${line01}|sed -e 's;^.*:;;g'|awk '{printf $2}')
            need01=$(echo ${line01}|sed -e 's;^.*:;;g'|awk '{printf $4}')
            re01=$((${now01} - ${last01}))
            re02=$((${need01} - ${re01}))
            echo "${now01}:${line01}:${last01}:${re01}:${re02}"
        ) || (
        tail -n 15 Loop.log.txt | grep -i '\[download\] Downloa' |tail -n 1
    )
    tail -n 1 Loop.log.txt |grep ETA |grep '\[download\]' |sed -e 's;[\r\n\t]; ;g' |sed -e 's;download;\n;g'|tail -n 1
    tail -n 3 Loop.log.txt | grep -q END1  && echo &&echo&&tail -n 3 Loop.log.txt |grep END1 && date -d '+16 hour'    +%Y%m%d__%H%M%p && echo && exit 3
	sleep 5
done
