#!/bin/sh

#    -r 1000 \

ffmpeg -y \
    -i "$1" \
    -qscale 0  \
    "x.$1.%06d.png"
