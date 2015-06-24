#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

wew | while IFS=: read ev wid; do
    case $ev in
        # occurs on mapping requests
        19) wattr o $wid || focus.sh $wid ;;
    esac
done
