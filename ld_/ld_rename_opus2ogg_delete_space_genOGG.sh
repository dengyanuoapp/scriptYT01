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
    echo
    echo
    exit
}

kill_youtube(){
        echo " skiped needed, try to kill 2"
        grep '' ../pid_now_yt.txt
        kill `cat ../pid_now_yt.txt`
}

chkeck_skip_kill(){
if [ -f "../skip_kill.txt" ]
then
    echo " ../skip_kill.txt exist , skip. "
else
    echo " ../skip_kill.txt don't exist , try to kill "
    if [ "${audio_skiped}" = '1' -o "${video_skiped}" = '1' ]
    then
        echo " skiped needed, try to kill 1"
        kill_youtube
    else
        echo " no skiped , no need to kill "
    fi
fi
}

delete_the_origin_file(){
    if [ "$3" != 'keep_origon' -a "$3" != 'ko' ] 
    then
        echo "rm -f \"${bb1}\""
              rm -f  "${bb1}"
    fi
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
# "${title} ${author}" 
skipName1="$(echo -n "${bb3}"|   \
    sed \
    -e 's;.*_;;g')"

echo
echo "change from 11 <$1>  to <${bb3}> , size <${bb2}> , skipName1<${skipName1}> "

if [ -n "${skipName1}" ]
then
    if [ -f skip/skip_${skipName1} ]
    then
        echo " file skipName1<${skipName1}> , found . skip . exit "
        delete_the_origin_file
        echo " skiped needed, try to kill 3"
        #chkeck_skip_kill
        kill_youtube
        exit
    else
        mkdir -p skip/
        touch skip/skip_${skipName1}
    fi
fi

AHcode=libopus
AHrate=12k
AHfreq=16000

ALcode=amr_nb
ALrate=4750
ALfreq=8000

#rate=4750
#freq=24000
#rate=4750
#rate=6700
#freq=8000

size1=48000111

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
        ppL=$(($(ffprobe -v quiet -print_format json -show_format "${bb1}" |grep duration|head -n 1|sed -e 's;",.*$;;g' -e 's;^.*";;g' -e 's;\..*$;;g' )))

        ppX1=$((${ppL}/3600)) ; ppX2=$(((${ppL}-${ppX1}*3600)/60)); ppX3=$((${ppL}-${ppX1}*3600-${ppX2}*60)) ; ppX="${ppX1}:${ppX2}:${ppX3}"
        echo "ppL:${ppL} ppX1:${ppX1} ppX2:${ppX2} ppX3:${ppX3} ppX:${ppX}"

        echo "format_parameter : ppW:<${ppW}> ppH:<${ppH}> ppX:<${ppX}> ppL:<${ppL}> "
        if [ -z "${ppW}" -o -z "${ppH}" -o -z "${ppL}" ] ; then
            echo "error pixel found <${ppW}><${ppH}><${ppL}>, skip "
        else
            if [ ${ppH} -lt ${ppW} ] ; then ################## w > h
                HH1=${ppW}     ### high pixel
                LL1=${ppH}     ### high pixel
            else
                HH1=${ppH}     ### high pixel
                LL1=${ppW}     ### high pixel
            fi
            LL1=$(( ${LL1} / 4 * 4 ))
            HH1=$(( ${HH1} / 4 * 4 ))

            ### max allow 48M
            ppZ1=55
            ppZ1=48
            ppZ2=$((${ppZ1} * 1000 * 1000 ))

            ### video leng limit max-speed. for exampel : ( 48000000 * 8  bits) / ( xxx second ) 
            ppZ4=$(( ${ppZ2} * 8 / ${ppL} ))

            ## the max limit speed ( bps ) 
            if [ ${ppZ4} -gt 200000 ] ## file-size-max-allow-speed > 200 kps
            then
                if [ ${HH1} -lt 720 ] ## less than 720 , use origin
                then
                    HH=${HH1}
                    LL=${LL1}
                    echo " ==debuging 1: enough file size. less then 720 , use origin pixel : ppZ4:${ppZ4} : HH:${HH} , LL:${LL}"
                else  ## larger than 720 , use 720
                    HH=720
                    LL=$(( ${LL1} * ${HH} / ${HH1} / 4 * 4 ))
                    echo " ==debuging 2: enough file size. large then 720 , use 720 pixel : ppZ4:${ppZ4} : HH:${HH} , LL:${LL}"
                fi
            else
                HH2=$(( ${ppZ4} * 720 / 200000 / 4 * 4))
                if [ ${HH2} -lt 360 ]
                then
                    if [ ${HH2} -lt 120 ]
                    then
                        HH=240
                    else
                        HH=360
                    fi
                else
                    HH=${HH2}
                fi
                LL=$(( ${LL1} * ${HH} / ${HH1} / 4 * 4 ))
                echo " ==debuging 3: no enough file size. reduce the pixel : ppZ4:${ppZ4} : HH:${HH} , LL:${LL} , HH2:${HH2} "
            fi


            echo " ==debuging 4: ppZ1<${ppZ1}> ppZ2<${ppZ2}> ppZ4<${ppZ4}> HH:${HH} , LL:${LL} , HH1:${HH1} , LL1:${LL1} , ppW:${ppW} , ppH:${ppH} , ppL:${ppL} "

            if [ ${ppH} -lt ${ppW} ] ; then ################## w > h
                export pp4="${HH}:${LL}"
            else
                export pp4="${LL}:${HH}"
            fi
            pp5="${ppW}x${ppH}"

            echo " -- pp4 -> ${pp4} -- pp5 -> ${pp5}"
            cput1=$(date +%s)
# -r 12 

if [ 1 = 1 ] ; then
#echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 15 -vf scale=\"${pp4}\" -maxrate ${ppZ8} -bufsize ${ppZ9} -acodec ${AHcode} -ac 1 -ar ${AHfreq} -ab ${AHrate}  -metadata title=\"${title}\" -metadata author=\"${author}_${pp5}\" -y \"${bb4}\""
#        nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 15 -vf  scale="${pp4}"  -maxrate ${ppZ8} -bufsize ${ppZ9} -acodec ${AHcode} -ac 1 -ar ${AHfreq} -ab ${AHrate}   -metadata title="${title}"  -metadata  author="${author}_${pp5}"  -y  "${bb4}" &
echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 10 -vf scale=\"${pp4}\" -acodec ${AHcode} -ac 1 -ar ${AHfreq} -ab ${AHrate}  -metadata title=\"${title}\" -metadata author=\"${author}_${pp5}\" -y \"${bb4}\""
        nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 10 -vf  scale="${pp4}"  -acodec ${AHcode} -ac 1 -ar ${AHfreq} -ab ${AHrate}   -metadata title="${title}"  -metadata  author="${author}_${pp5}"  -y  "${bb4}" &
        export pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; sleep 2 ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
sizeVV4="`ls -lh "${bb4}" |head -n 1|awk '{print $5}'`"
fi
            echo "change from 22 <$1>  to <${bb4}> <${sizeVV4}>"
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
    #bb4="${bb3}.ogg"
    bb4="${bb3}.amr"
    if [ -f "${bb4}".ogg -o -f "X${bb4}".ogg ] ; then
        echo " already exist . skip ${bb4}"
        audio_skiped=1
    else 
        cput1=$(date +%s)
if [ 1 = 1 ] ; then
#echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vn -acodec ${ALcode}               -ac 1 -ar ${ALfreq} -ab ${ALrate}  -metadata title=\"${title}\" -metadata author=\"${author}\" -y \"${bb4}\""
#        nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec ${ALcode} -ac 1 -ar ${ALfreq} -ab ${ALrate}   -metadata title="${title}"  -metadata  author="${author}"  -y  "${bb4}" &
#export  pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; sleep 2 ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
        nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec ${AHcode} -ac 1 -ar ${AHfreq} -ab ${AHrate}   -metadata title="${title}"  -metadata  author="${author}"  -y  "X${bb4}.ogg" &
export  pid1=$! ; echo ${pid1} > ../../pid_now_ff.txt ; sleep 2 ; echo "pid1->${pid1}" ; echo -n ${pid1} | nc 127.0.0.1 33778 ; wait ${pid1}
sizeAA41="`ls -lh  "${bb4}"     |head -n 1|awk '{print $5}'`"
sizeAA42="`ls -lh X"${bb4}".ogg |head -n 1|awk '{print $5}'`"
fi
        echo "change from 33 <$1>  to <${bb4}> <${sizeAA41}> <${sizeAA42}>"
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
# ${title} ${author} 
    [ -n "${git_vo}" ] && git_up=1 && git add *"${git_vo}"* && git commit -a -m "${sizeVV4}_${pp4}_${git_vo} ${author} ${title} " 
    [ -n "${git_ao}" ] && git_up=1 && git add *"${git_ao}"* && git commit -a -m "${sizeAA41}_${sizeAA42}_${git_ao}_ogg ${author} ${title} " 
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



delete_the_origin_file

echo "== audio_skiped ${audio_skiped}, video_skiped ${video_skiped}, conv_ogg ${conv_ogg}, conv_mkv ${conv_mkv}"

chkeck_skip_kill

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
