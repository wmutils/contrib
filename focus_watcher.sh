#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

wew | while read ev wid args; do
    case $ev in
        # occurs on mapping requests
        MAP) wattr o $wid || focus.sh $wid ;;
    esac
done
