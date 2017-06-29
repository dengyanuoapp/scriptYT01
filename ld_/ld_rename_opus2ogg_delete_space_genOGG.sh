#!/bin/sh

ls -l "$1"

if [ ! -f "$1" ] 
then
    echo 
    echo "<$1> don't exist. exit."
    echo 
    exit
fi

# scale="720:trunc(ow/a/2)*2" scale="trunc(oh*a/2)*2:720"
bb1="${1}"
ls -l "${bb1}" 

bb2=$(cat "${bb1}"|wc -c)

bb3="_$(echo -n "$1"|tr -d \'|tr -d \"|sed -e 's;[ \t\r\n&=\-\|\+\@\#,]*;;g' -e 's;__*;_;g' -e 's;^201;1;g' -e 's;\.mp4$;;g' -e 's;\.mkv$;;g' -e 's;\.m4a$;;g' -e 's;\.mp[234]$;;g' -e 's;\.webm$;;g' -e 's;\.opus$;;g')"


echo
echo "change from <$1>  to <${bb3}> , size <${bb2}"

rate=16k
freq=24000

if [ "$2" = 'mkv' ]
then
    size1=95111000111
else
    size1=155000111
fi

video_skiped=0
audio_skiped=0

conv_mkv=0
conv_ogg=1

git_vo=
git_ao=

## if specified 2nd para as mkv , or , the origin file less than 150M , then , gen an x265 mkv file.
[ "$2" = 'mkv' ]                              && conv_mkv=1
[ -n "${bb2}" -a "${bb2}" -lt "${size1}" ]    && conv_mkv=1

if [ "$2" = 'aoo' ] 
then
    conv_mkv=0    ### aoo -> audio_only
    conv_ogg=1    ### aoo -> audio_only
fi
if [ "$2" = 'voo' ] 
then
    conv_mkv=1    ### voo -> video_only
    conv_ogg=0    ### voo -> video_only
fi


if [ "${conv_mkv}" = 1 ] 
then
    bb4="${bb3}.mkv"
    if [ -f "${bb4}" ] ; then
        echo " already exist . skip ${bb4}"
        video_skiped=1
    else 
        ppW=$(ffprobe -v quiet -print_format json -show_format -show_streams "${bb1}" |grep coded_width  |head -n 1|awk -F : '{print $2}'|tr -d ',')
        ppH=$(ffprobe -v quiet -print_format json -show_format -show_streams "${bb1}" |grep coded_height |head -n 1|awk -F : '{print $2}'|tr -d ',')
        #scale91='trunc(ow*a/2)*2:'
        #scale92=':trunc(oh*a/2)*2'
        scale91='w=360:h=240:force_original_aspect_ratio=decrease'
        scale92='w=240:h=360:force_original_aspect_ratio=decrease'
        if [ -z "${ppW}" -o -z "${ppH}" ] ; then
            echo "error pixel found <${ppW}><${ppH}>, skip "
        else
            if [ ${ppH} -lt ${ppW} ] ; then ################## w > h
                if [ ${ppH} -lt 360 ] ; then ### w < 360 , ok , no need to chang
                    nnW=${ppW}
                    nnH=${ppH}
                else                        ### w >= 360 , force w to 360
                    nnW=360
                    nnH=$(( ${ppH} * 360 / ${ppW} / 4 * 4 ))
                fi
                pp4="${nnW}:${nnH}"
            else                            ################## w <= h
                if [ ${ppH} -lt 360 ] ; then ## w < h < 360
                    nnW=${ppW}
                    nnH=${ppH}
                else                         ## w < h > 360 , force h to 360
                    nnH=360
                    nnW=$(( ${ppW} * 360 / ${ppH} / 4 * 4 ))
                fi
                pp4="${nnW}:${nnH}"
            fi
            cput1=$(date +%s)
if [ -z "${af}" ] ; then
    echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 12 -vf scale=\"${pp4}\" -acodec libopus               -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y \"${bb4}\""
            nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 12 -vf  scale="${pp4}"  -acodec libopus               -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y  "${bb4}"
else
    echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 12 -vf scale=\"${pp4}\" -acodec libopus -af \"${af}\" -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y \"${bb4}\""
            nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 12 -vf  scale="${pp4}"  -acodec libopus -af  "${af}"  -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y  "${bb4}"
fi
            echo "change from <$1>  to <${bb4}> "
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
    if [ -f "${bb4}" ] ; then
        echo " already exist . skip ${bb4}"
        audio_skiped=1
    else 
        cput1=$(date +%s)
if [ -z "${af}" ] ; then
        echo   "nice -n 19 ffmpeg -vn -i \"${bb1}\" -acodec libopus -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y \"${bb4}\""
                nice -n 19 ffmpeg -vn -i  "${bb1}"  -acodec libopus -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y  "${bb4}"
else
        echo   "nice -n 19 ffmpeg -vn -i \"${bb1}\" -acodec libopus -af \"${af}\" -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y \"${bb4}\""
                nice -n 19 ffmpeg -vn -i  "${bb1}"  -acodec libopus -af  "${af}"  -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y  "${bb4}"
fi
        echo "change from <$1>  to <${bb4}> "
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
    [ -n "${git_vo}" ] && git_up=1 && git add "${git_vo}" && git commit -a -m "${git_vo}" 
    [ -n "${git_ao}" ] && git_up=1 && git add "${git_ao}" && git commit -a -m "${git_ao}" 
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
    echo ' skip git_up'
fi



#delete the origin file
if [ -n "$2" ] 
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

if [ -n "${cput4a}" ]
then
    echo " need to limit cpu , sleep : ${cput1} ${cput2} ${cput3} ${cput4a} "
    sleep ${cput4a}
fi

if [ -n "${cput4v}" ]
then
    echo " need to limit cpu , sleep : ${cput1} ${cput2} ${cput3} ${cput4v} "
    sleep ${cput4v}
fi
