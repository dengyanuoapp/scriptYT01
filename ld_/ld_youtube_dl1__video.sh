#!/bin/sh

UU=zn_CN.UTF-8 
UU=en_US.UTF-8 

# --restrict-filenames

echo   "LC_CTYPE=${UU} nice -n 19 youtube-dl   --no-check-certificate   -o '%(upload_date)s_%(title)s_%(id)s.%(ext)s'    $*"
        LC_CTYPE=${UU} nice -n 19 youtube-dl   --no-check-certificate   -o '%(upload_date)s_%(title)s_%(id)s.%(ext)s'    $*
