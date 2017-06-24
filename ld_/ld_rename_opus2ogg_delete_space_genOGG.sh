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
        pp1=$(ffprobe -v quiet -print_format json -show_format -show_streams "${bb1}" |grep coded_width  |head -n 1|awk -F : '{print $2}'|tr -d ',')
        pp2=$(ffprobe -v quiet -print_format json -show_format -show_streams "${bb1}" |grep coded_height |head -n 1|awk -F : '{print $2}'|tr -d ',')
        scale91='trunc(oh*a/2)*2:'
        scale92=':trunc(ow*a/2)*2'
        if [ -z "${pp1}" -o -z "${pp1}" ] ; then
            echo "error pixel found <${pp1}><${pp2}>, skip "
        else
            if [ ${pp2} -lt ${pp1} ] ; then
                if [ ${pp2} -lt 360 ] ; then
                    pp3=240
                else
                    pp3=360
                fi
                pp4="${scale91}${pp3}"
            else
                if [ ${pp1} -lt 360 ] ; then
                    pp3=240
                else
                    pp3=360
                fi
                pp4="${pp3}${scale92}"
            fi
            #echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 12 -vf scale='trunc(oh*a/2)*2:360' -acodec libopus -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y \"${bb4}\""
            #        nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 12 -vf scale='trunc(oh*a/2)*2:360' -acodec libopus -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y  "${bb4}"
            echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vcodec libx265 -r 12 -vf scale=\"${pp4}\" -acodec libopus -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y \"${bb4}\""
                    nice -n 19 ffmpeg -i  "${bb1}"  -vcodec libx265 -r 12 -vf  scale="${pp4}"  -acodec libopus -ac 1 -maxrate ${rate} -ar ${freq} -ab ${rate} -y  "${bb4}"
            echo "change from <$1>  to <${bb4}> "
            ls -l "${bb4}" 
            [ -f ../New_add_gen1.txt ] && echo "$(basename ${PWD})/${bb4}" >> ../New_add_gen1.txt 
            git_vo="${bb4}" 
        fi
        echo "------------${pp1}, ${pp2}, ${pp3}, ${pp4}-----------"
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
        echo   "nice -n 19 ffmpeg -vn -i \"${bb1}\" -ac 1 -maxrate ${rate} -ar ${freq} -f opus -ab ${rate} -y \"${bb4}\""
                nice -n 19 ffmpeg -vn -i  "${bb1}"  -ac 1 -maxrate ${rate} -ar ${freq} -f opus -ab ${rate} -y  "${bb4}"
        echo "change from <$1>  to <${bb4}> "
        ls -l "${bb4}" 
        [ -f ../New_add_gen1.txt ] && echo "$(basename ${PWD})/${bb4}" >> ../New_add_gen1.txt 
        git_ao="${bb4}" 
    fi
fi

if [ -f ../.git/COMMIT_EDITMSG ]
then
    echo ' trying git_up'
    git_up=
    [ -n "${git_vo}" ] && git_up=1 && git add "${git_vo}" && git commit -m "${git_vo}" 
    [ -n "${git_ao}" ] && git_up=1 && git add "${git_ao}" && git commit -m "${git_ao}" 
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

