#!/bin/bash

usageExit() {
    echo 
    echo "ffmpeg -i input.mp4 -c copy -map 0 -segment_time 8 -f segment output%03d.mp4"
    echo "ffmpeg -i $1 -c copy -map 0 -segment_time 8 -f segment output_%03d_$1"
    echo 
    exit
}

if [ -z "$1" -o "$1" = '-h' -o "$1" = 'h' -o "$1" = 'help' -o "$1" = '-help'  ]
then
    usageExit
fi

    echo "ffmpeg -i $1 -c copy -map 0 -segment_time 8 -f segment output_%03d_$1"
          ffmpeg -i $1 -c copy -map 0 -segment_time 8 -f segment output_%03d_$1

