#!/bin/bash

aa=$1
[ -z "$1" ] && aa=input  || aa=$1

echo \
    "ffmpeg -i ${aa} -vcodec copy -acodec copy ${aa}.mkv"

[ -z "$1" ] || \
     ffmpeg -i ${aa} -vcodec copy -acodec copy ${aa}.mkv 
