#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL license
#
# When used puts all the windows in a grid and when you focus one of the windows
# it puts all the windows back to their original location and focuses the window
# you switched to.
# depends on: wew focus.sh

# get monitor dimensions
ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)

# couple vars we need
PFW=$(pfw)
TEMP=$(mktemp) && wattr xywhi $(lsw) > $TEMP
BW=${BW:-4} # exactly the width of your borders

# figure out the dimensions of the windows and locations
W=$(( SW / $(wc -l < $TEMP) )) # each window's width
H=$(( SH - BW * 2 )) # each window's height
X=0 # initial position
Y=0 # initial position

# loop through them and make a grid or something similar
# TODO: make an actual grid instead of just putting all the windows together
#       horizontally
while read line; do
    ID=$(echo $line | cut -d " " -f 5)
    wtp $X $Y $((W - BW * 2)) $H $ID
    X=$((X + W))
done < $TEMP

# listen to wew for our desired event
# TODO: currently listens for ENTER_WINDOW, should listen for KEY_PRESS/RELEASE
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
    # TODO: if the currently focused window is clicked just put everything back
    #       together
done

# cleanup
rm $TEMP
