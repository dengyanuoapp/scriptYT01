#!/bin/bash

if [ -z "${1}" ]
then
	echo
	echo usage : $0 <filename> [width]
	echo
	exit
fi
[ -z "$2" ] && WWW="5120:-1" || WWW="${2}:-1"

dst1=$(basename $1)
dst2=${dst1}.%05d.jpg

# /usr/bin/ffmpeg  -i ${1}  -vf scale=5120:-1 -qscale:v 2  Bf2huTkYzs.mkv.mkv.%05d.jpg

echo /usr/bin/ffmpeg  -i ${1}  -vf scale=${WWW} -qscale:v 2  ${dst2}
     /usr/bin/ffmpeg  -i ${1}  -vf scale=${WWW} -qscale:v 2  ${dst2}
