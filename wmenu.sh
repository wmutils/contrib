#!/bin/sh
#
# fyr | 2019 (c) MIT
# dmenu wrapper to select windows based on their window title
# use xprop -id $wid WM_NAME or WM_CLASS for better matching

LINES=$(lsw | wc -l)

wid=$(\
    for wid in $(lsw); do
        printf '%s\n' "$wid | $(wname $wid)"
    done | dmenu -name "wmenu" -l $LINES -p "Window:" | cut -d\  -f 1)

test -n "$wid" && focus.sh "$wid"
