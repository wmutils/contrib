#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

wew -m 16 | while IFS=: read ev wid; do
    case $ev in
        # XCB_CREATE_NOTIFY
        16) focus.sh $wid ;;
    esac
done
