#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL license
#
# When used puts all the windows in a grid and when you focus one of the windows
# it puts all the windows back to their original location and focuses the window
# you switched to.
# depends on: wew focus.sh

TEMP=$(mktemp) && wattr xywhi $(lsw) > $TEMP
AMOUNT=$(wc -l < $TEMP)

# just safety
if [ $AMOUNT -eq 1 ]; then
    exit
fi

# user defined
#BW=${BW:-4} # exactly the width of your borders
COLS=${COLS:-4} # how many columns do you want?
ROWS=${ROWS:-2} # how many rows do you want?

# get monitor dimensions
ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)

# figure out the dimensions of the windows
W=$(( SW / COLS )) # each window's width
H=$(( SH / ROWS )) # each window's height

# and their initial locations
X=0 # initial position
Y=0 # initial position
COUNT=0 # first window

# loop through the windows and make a grid
while read line; do
    ID=$(echo $line | cut -d " " -f 5) # current WID

    wtp $X $Y $W $H $ID

    COUNT=$((COUNT + 1))

    if [ $COUNT -eq $COLS ]; then
        X=0
        Y=$(( (H * ROWS) - H ))
    else
        X=$((X + W))
    fi
done < $TEMP

# listen to wew for our desired event
wew | while IFS=: read ev wid; do
    case $ev in
        4)
            while read line; do
                wtp $line
            done < $TEMP
            focus.sh $wid
            exit
            ;;
    esac
done

# cleanup
rm $TEMP
