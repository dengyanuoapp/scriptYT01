#!/bin/sh

usage01() {
    echo
    echo
    echo " Usage : $0 <filename.in>  [aoo|voo|aoovoo|vooaoo] {keep_origon|ko}"
    echo '         aoo              -> audio only '
    echo '         voo              -> video only '
    echo '         vooaoo , aoovoo  -> video and audio '
    echo '         ko , keep_origin -> skip to delete the origin file.'
    echo
    echo ' if , need to scale the volumn of the audio volumn : '
    echo '         af="volume=1.5"' "$0 <filename.in>  [aoo|voo|aoovoo|vooaoo] {keep_origon|ko}"
    echo
    echo
    exit
}

ls -l "$1"

if [ -z "$1" -o ! -f "$1" ] 
then
    usage01
fi



# 4750  5150 5900  6700  7400 7950 10200 12200
# scale="720:trunc(ow/a/2)*2" scale="trunc(oh*a/2)*2:720"
bb1="${1}"
ls -l "${bb1}" 

bb2=$(cat "${bb1}"|wc -c)

bb3="_$(echo -n "$1"|   \
    tr -d \'|   \
    tr -d \"|   \
    tr -d '-' | \
    tr -d '?' | \
    tr -d '&' | \
    tr -d '=' | \
    tr -d '|' | \
    tr -d '+' | \
    tr -d '@' | \
    tr -d '#' | \
    tr -d ',' | \
    tr -d '/' | \
    tr -d ' ' | \
    tr -d '(' | \
    tr -d ')' | \
    tr -d '[' | \
    tr -d ']' | \
    tr -d '{' | \
    tr -d '}' | \
    sed -e 's;[\t\r\n]*;;g' \
    -e 's;__*;_;g' \
    -e 's;^201;1;g' \
    -e 's;\.mp4$;;g' \
    -e 's;\.mkv$;;g' \
    -e 's;\.m4a$;;g' \
    -e 's;\.mp[234]$;;g' \
    -e 's;\.webm$;;g' \
    -e 's;\.opus$;;g')"


author=`ls 00*.ogg|head -n 1|sed -e 's;^00_;;g' -e 's;\.ogg;;g'`_`echo -n "$1"|sed -e 's;_.*$;;g'`
title1=`echo -n "${bb3}"|sed -e 's;__*[^_]*$;;g' -e 's;^.*_;;g'`
title=${title1}

# -metadata title="kkk" 
# -metadata author="aaa" 
# -metadata title="${title}" -metadata author="${author}" 

echo
echo "change from <$1>  to <${bb3}> , size <${bb2}"

VOcode=libopus
VOrate=12k
VOfreq=16000

AOcode=amr_nb
AOrate=4750
AOfreq=8000

rate=4750
freq=24000

rate=4750
rate=6700
freq=8000

if [ "$2" = 'mkv' ]
then
    size1=95111000111
else
    size1=155000111
fi
size1=95111000111

video_skiped=0
audio_skiped=0

conv_mkv=
conv_ogg=

git_vo=
git_ao=

## if specified 2nd para as mkv , or , the origin file less than 150M , then , gen an x265 mkv file.
#########################3### aoo -> audio_only
if [ "$2" = 'aoo' ]
then
    conv_mkv=0    
    conv_ogg=1    
fi
#########################3### ### voo -> video_only
if [ "$2" = 'voo' ] 
then
    conv_mkv=1    
    conv_ogg=0    
fi
#########################3### ### aoovoo vooaoo-> video and audio
if [ "$2" = 'vooaoo' -o "$2" = 'aoovoo' ] 
then
    conv_mkv=1    ### 
    conv_ogg=1    ### 
fi

if [ -z "${conv_mkv}" ]
then
    usage01
fi


if [ "${conv_mkv}" = 1 ] 
then
    bb4="${bb3}.mkv"
    if [ -f "${bb4}" ] ; then
        echo " already exist . skip ${bb4}"
        video_skiped=1
    else 
        # ffprobe -v quiet -print_format json -show_format -show_streams 

        ppW=$(ffprobe -v quiet -print_format json -show_streams "${bb1}" |grep coded_width  |head -n 1|awk -F : '{print $2}'|tr -d ','|tr -d ' ')
        ppH=$(ffprobe -v quiet -print_format json -show_streams "${bb1}" |grep coded_height |head -n 1|awk -F : '{print $2}'|tr -d ','|tr -d ' ')
        ppX=$(ffprobe -v quiet -print_format json -show_streams "${bb1}" |grep DURATION|head -n 1|tr -d '"'|sed -e 's;\.[0-9]*$;;g' -e 's;^.* ;;g')
        ppL=$(($(ffprobe -v quiet -print_format json -show_format "${bb1}" |grep duration|head -n 1|sed -e 's;",.*$;;g' -e 's;^.*";;g' -e 's;\..*$;;g' )))
        echo "format parameter : <${ppW}><${ppH}><${ppX}> <${ppL}> "
        if [ -z "${ppW}" -o -z "${ppH}" -o -z "${ppL}" ] ; then
            echo "error pixel found <${ppW}><${ppH}><${ppL}>, skip "
        else
            if [ ${ppL} -lt 7000 ]
            then
                ssW=360
            else
                ssW=180
                ssW=160
            fi
            ppZ1=2588000
            ppZ1=3009280
            ppZ2=$(( ${ppZ1} / ${ppL} ))
            ppZ3=$(( ${ppZ2} / 16 ))
            ppZ4=$(( ${ppZ3} * 16 ))
            if [ ${ppZ4} -lt 160 ] ; then
                ppZ5=160
            elif [ ${ppZ4} -gt 720 ] ; then
                ppZ5=720
            else
                ppZ5=${ppZ4}
            fi


            echo "ppZ1,2,3,4,5:${ppZ1}, ${ppZ2}, ${ppZ3}, ${ppZ4}, ${ppZ5}"
            ssW=${ppZ5}


            if [ ${ppH} -lt ${ppW} ] ; then ################## w > h
                if [ ${ppW} -lt ${ssW} ] ; then ### h < w < ${ssW} , ok , no need to chang
                    echo " -- db 1"
                    nnW=${ppW}
                    nnH=${ppH}
                else                        ### w >= ${ssW} , force w to ${ssW}
                    echo " -- db 2"
                    nnW=${ssW}
                    nnH=$(( ${ppH} * ${ssW} / ${ppW} / 4 * 4 ))
                fi
                pp4="${nnW}:${nnH}"
            else                            ################## w <= h
                if [ ${ppH} -lt ${ssW} ] ; then ## w < h < ${ssW}
                    echo " -- db 3"
                    nnW=${ppW}
                    nnH=${ppH}
                else                         ## w < h > ${ssW} , force h to ${ssW}
                    echo " -- db 4"
                    nnH=${ssW}
                    nnW=$(( ${ppW} * ${ssW} / ${ppH} / 4 * 4 ))
                fi
                pp4="${nnW}:${nnH}"
            fi
            echo " -- pp4 -> ${pp4}"
            cput1=$(date +%s)
if [ -z "${af}" ] ; then
    echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 12 -vf scale=\"${pp4}\" -acodec ${VOcode}                 -ac 1 -ar ${VOfreq} -ab ${VOrate}  -metadata title="${title}" -metadata author=\"${author}\" -y \"${bb4}\""
            nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 12 -vf  scale="${pp4}"  -acodec ${VOcode}                 -ac 1 -ar ${VOfreq} -ab ${VOrate}  -metadata title="${title}" -metadata  author="${author}"  -y  "${bb4}" &
		    export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
else
    echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 12 -vf scale=\"${pp4}\" -acodec ${VOcode} -af \"${af}\"   -ac 1 -ar ${VOfreq} -ab ${VOrate}  -metadata author=\"${author}\" -y \"${bb4}\""
            nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 12 -vf  scale="${pp4}"  -acodec ${VOcode} -af  "${af}"    -ac 1 -ar ${VOfreq} -ab ${VOrate}  -metadata  author="${author}"  -y  "${bb4}" &
		    export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
fi
sizeVV4="`ls -lh ${bb4} |awk '{print $5}'`"
            echo "change from <$1>  to <${bb4}> <${sizeVV4}>"
            ls -l "${bb4}" 
            [ -f ../New_add_gen1.txt ] && echo "$(basename ${PWD})/${bb4}" >> ../New_add_gen1.txt 
            git_vo="${bb4}" 
            if [ -f ../Cpu_limit.txt ] ; then
                cput2=$(date +%s)
                cput3=$((${cput2} - ${cput1}))
                cput4v=$((${cput3} * 1))
            else
                echo " don't need to limit cpu "
            fi
        fi
        echo "------------${ppW}, ${ppH}, ${nnW}, ${nnH}, ${pp4}-----------"
    fi
fi

## always gen the ogg.
if [ "${conv_ogg}" = 1 ] 
then
    bb4="${bb3}.ogg"
    bb4="${bb3}.amr"
    if [ -f "${bb4}" ] ; then
        echo " already exist . skip ${bb4}"
        audio_skiped=1
    else 
        cput1=$(date +%s)
if [ -z "${af}" ] ; then
        echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vn -acodec ${AOcode}               -ac 1 -ar ${AOfreq} -ab ${AOrate}  -metadata author=\"${author}\" -y \"${bb4}\""
                nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec ${AOcode}               -ac 1 -ar ${AOfreq} -ab ${AOrate}  -metadata  author="${author}"  -y  "${bb4}" &
		export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
                nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec ${VOcode}               -ac 1 -ar ${VOfreq} -ab ${VOrate}  -metadata  author="${author}"  -y  "X${bb4}.ogg" &
		export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
else                                                
        echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vn -acodec ${AOcode} -af \"${af}\" -ac 1 -ar ${AOfreq} -ab ${AOrate}  -metadata author=\"${author}\" -y \"${bb4}\""
                nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec ${AOcode} -af  "${af}"  -ac 1 -ar ${AOfreq} -ab ${AOrate}  -metadata  author="${author}"  -y  "${bb4}" &
		export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
                nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec ${VOcode} -af  "${af}"  -ac 1 -ar ${VOfreq} -ab ${VOrate}  -metadata  author="${author}"  -y  "X${bb4}.ogg" &
		export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
fi
sizeAA41="`ls -lh ${bb4}      |awk '{print $5}'`"
sizeAA42="`ls -lh X${bb4}.ogg |awk '{print $5}'`"
        echo "change from <$1>  to <${bb4}> <${sizeAA41}> <${sizeAA42}>"
        ls -l "${bb4}" 
        [ -f ../New_add_gen1.txt ] && echo "$(basename ${PWD})/${bb4}" >> ../New_add_gen1.txt 
        git_ao="${bb4}" 
        if [ -f ../Cpu_limit.txt ] ; then
            cput2=$(date +%s)
            cput3=$((${cput2} - ${cput1}))
            cput4a=$((${cput3} * 1))
        else
            echo " don't need to limit cpu "
        fi
    fi
fi

if [ -f ../.git/COMMIT_EDITMSG ]
then
    echo ' trying git_up'
    git_up=
    [ -n "${git_vo}" ] && git_up=1 && git add *"${git_vo}"* && git commit -a -m "${sizeVV4}_${pp4}_${git_vo}" 
    [ -n "${git_ao}" ] && git_up=1 && git add *"${git_ao}"* && git commit -a -m "${sizeAA41}_${sizeAA42}_${git_ao}_ogg" 
    echo " git_up ${git_up} , git_vo ${git_vo} , git_ao ${git_ao} " 
    if [ -n "${git_up}" ] 
    then
        echo " real git_up "
        nice -n 15 git status
        nice -n 15 git push -u origin master
    else
        echo " no file gen , skip git_up "
    fi
else
    echo ' no git directory , skip git_up'
fi



#delete the origin file
if [ "$3" != 'keep_origon' -a "$3" != 'ko' ] 
then
    echo "rm -f \"${bb1}\""
          rm -f  "${bb1}"
fi

echo "== audio_skiped ${audio_skiped}, video_skiped ${video_skiped}, conv_ogg ${conv_ogg}, conv_mkv ${conv_mkv}"

if [ -f "../skip_kill.txt" ]
then
    echo " ../skip_kill.txt exist , skip. "
else
    echo " ../skip_kill.txt don't exist , try to kill "
    if [ "${audio_skiped}" = '1' -o "${video_skiped}" = '1' ]
    then
        echo " skiped needed, try to kill "
        grep '' ../pid_now_yt.txt
        kill `cat ../pid_now_yt.txt`
    else
        echo " no skiped , no need to kill "
    fi
fi

if [ 0 = 1 ]
then
    echo " use cpu limit , no sleep . 0Need to limit cpu , sleep : ${cput1} ${cput2} ${cput3} ${cput4a} "
    sleep 65
else
    if [ -n "${cput4a}" ]
    then
        cput4c='' ; [ -f /tmp/cpu_sleep.txt ] && cput4c=`cat /tmp/cpu_sleep.txt` 
        [ -z "${cput4c}" ] && cput4c=${cpu4a} 
        echo " 1Need to limit cpu , sleep : ${cput1} ${cput2} ${cput3} ${cput4a} ${cput4c}"
        sleep ${cput4c}
    fi
    
    if [ -n "${cput4v}" ]
    then
        cput4c='' ; [ -f /tmp/cpu_sleep.txt ] && cput4c=`cat /tmp/cpu_sleep.txt` 
        [ -z "${cput4c}" ] && cput4c=${cpu4v} 
        echo " 2Need to limit cpu , sleep : ${cput1} ${cput2} ${cput3} ${cput4v} ${cput4c}"
        sleep ${cput4c}
    fi
fi
