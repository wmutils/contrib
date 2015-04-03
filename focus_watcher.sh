#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

wew | while IFS=: read ev wid; do
    case $ev in
        # occurs on mapping requests
        19)
        ro=$(wattr o $wid)
        if (( $ro == 1 )); then
            focus.sh $wid
        fi;;
    esac
done
