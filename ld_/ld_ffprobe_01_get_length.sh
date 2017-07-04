#!/bin/sh

usage01() {
    echo
    echo
    echo " Usage : $0 <filename.in>  "
    echo
    exit
}

ls -l "$1"

if [ -z "$1" -o ! -f "$1" ] 
then
    usage01
fi

bb1="${1}"

ppW=$(ffprobe -v quiet -print_format json -show_streams "${bb1}" |grep coded_width  |head -n 1|awk -F : '{print $2}'|tr -d ','|tr -d ' ' )
ppH=$(ffprobe -v quiet -print_format json -show_streams "${bb1}" |grep coded_height |head -n 1|awk -F : '{print $2}'|tr -d ','|tr -d ' ' )
ppX=$(ffprobe -v quiet -print_format json -show_streams "${bb1}" |grep DURATION|head -n 1|tr -d '"'|sed -e 's;\.[0-9]*$;;g' -e 's;^.* ;;g')
ppL=$(($(ffprobe -v quiet -print_format json -show_format "${bb1}" |grep duration|head -n 1|sed -e 's;",.*$;;g' -e 's;^.*";;g' -e 's;\..*$;;g' )))
echo "format parameter : <${ppW}><${ppH}><${ppX}> <${ppL}> "
