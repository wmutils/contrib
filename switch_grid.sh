#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the ISC license
#
# When used puts all the windows in a grid and when you focus one of the windows
# it puts all the windows back to their original location and focuses the window
# you switched to

ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)
TEMP=$(mktemp)
wattr xywhi $(lsw) > $TEMP

# figure out the dimensions of the windows and locations
W=$(( SW / $(wc -l < $TEMP) ))
H=$SH
X=0
Y=0

# loop through them and make a grid or something similar
while read line; do
    ID=$(echo $line | cut -d " " -f 5)
    wtp $X $Y $W $H $ID
    X=$((X + W))
done < $TEMP

# loop through wew or whatever to hear for event #9 (XCB_FOCUS_IN)
wew -a | while IFS=: read ev wid; do
    case $ev in
        # XCB_FOCUS_IN
        9)
            while read line; do
                wtp $line
       	    done < $TEMP
       	    focus.sh $wid
            ;;
    esac
done
