#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL license
#
# When used puts all the windows in a grid and when you focus one of the windows
# it puts all the windows back to their original location and focuses the window
# you switched to.
# depends on: wew focus.sh

ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)
PFW=$(pfw)
TEMP=$(mktemp) && wattr xywhi $(lsw) > $TEMP
BW=2

# figure out the dimensions of the windows and locations
W=$(( SW / $(wc -l < $TEMP) ))
H=$SH
X=0
Y=0

# loop through them and make a grid or something similar
while read line; do
    ID=$(echo $line | cut -d " " -f 5)
    # TODO: fix this simple math so that all the spaces are exactly the same
    wtp $((X + BW * 2)) $((Y + BW * 2)) $((W - BW * 6)) $((H - BW * 6)) $ID
    X=$((X + W))
done < $TEMP

# loop through wew to hear for when you focus a new window
wew -m 16 | while IFS=: read ev wid; do
    case $ev in
        22)
            while read line; do
                wtp $line
            done < $TEMP
       	    focus.sh $wid
            exit
            ;;
        *)
            while read line; do
                wtp $line
            done < $TEMP
            focus.sh $PFW
            exit
            ;;
    esac
    # TODO: add a thing so that if the same window is clicked it puts windows
    #       back and focuses the same window
done

# cleanup
rm $TEMP
