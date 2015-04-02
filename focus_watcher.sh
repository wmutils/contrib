#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

wew -a | while IFS=: read ev wid; do
    case $1 in
        # occurs on mapping requests
        19) focus.sh $wid ;;
    esac
done
