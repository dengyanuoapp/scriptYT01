#!/bin/sh

ls -l "$1"

if [ ! -f "$1" ] 
then
    echo 
    echo "<$1> don't exist. exit."
    echo 
    exit
fi

ls -l "$1" 

bb1=$(echo -n "$1"|sed -e 's;[ \t\r\n&=\-\|\+\@\#]*;;g' -e 's;__*;_;g' -e 's;\.opus$;.ogg;g')
if [ "$1" = "${bb1}" ]
then
    echo 
    echo "file name ok <$1>. "
    echo 
    exit
fi

echo
echo "change from <$1>  to <${bb1}> "
mv "$1"  "${bb1}" 
ls -l "${bb1}" 

