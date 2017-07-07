#!/bin/sh

usage01() {
    echo
    echo
    echo ' Usage : '
    echo '        if , need to scale the volumn of the audio volumn : '
    echo "        $0   <filename.in>  <scaleX>"
    echo
    echo "    now : $0 $*"
    echo
    echo
    echo
    exit
}


if [ -z "$2" -o ! -f "$1" ] 
then
    usage01
fi
ls -l "$1"



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


#    echo '         af="volume=1.5"' "$0 <filename.in>  [aoo|voo|aoovoo|vooaoo] {keep_origon|ko}"

echo   "nice -n 19 ffmpeg -i \"${bb1}\" -vn -acodec libopus -af \"volume=${2}\" -ac 1 -y \"${bb3}.ogg\""
        nice -n 19 ffmpeg -i  "${bb1}"  -vn -acodec libopus -af  "volume=${2}"  -ac 1 -y  "${bb3}.ogg" &

