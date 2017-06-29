#!/bin/sh


if [ -z "$1" -o ! -f "$1" ] 
then
    echo 
    echo "<$1> don't exist. exit."
    echo 
    exit
fi

ls -l "$1"

bb1=$(echo -n "$1"|sed -e 's;[ /\t\r\n&=\-\|\+\@\#]*;;g' -e 's;__*;_;g')
for aa1 in 1 2 3 4 5 6
do
    bb1=$(echo -n "${bb1}"|sed \
        -e 's;\.opus$;;g' \
        -e 's;\.ogg$;;g' \
        -e 's;\.mp4$;;g' \
        -e 's;\.m4a$;;g' \
        -e 's;\.mkv$;;g' \
    )
done


if [ -z "${bb1}" -o "$1" = "${bb1}" ]
then
    echo 
    echo "file name failed <$1>. "
    echo 
    exit
fi
bb1=${bb1}.ao.ogg

echo
echo "change from <$1>  to <${bb1}> "

ffmpeg \
    -i ${1}    \
    -vn \
    -acodec copy \
    -y \
    ${bb1}

ls -l "${bb1}" 

