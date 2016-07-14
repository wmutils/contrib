#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# find and focus the closest window in a specific direction
# depends on: focus.sh

# get current window id
CUR=$(pfw)

usage() {
    echo "usage: $(basename $0) <direction>" >&2
    exit 1
}

next_west() {
    lsw | xargs wattr xi | sort -nr | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

next_east() {
    lsw | xargs wattr xi | sort -n | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

next_north() {
    lsw | xargs wattr yi | sort -nr | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

next_south() {
    lsw | xargs wattr yi | sort -n | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

# Use the specification of your choice: WASD, HJKL, ←↑↓→, west/north/south/east
case $1 in
    h|a|west|left)  wid=$(next_west)  ;;
    j|s|south|down) wid=$(next_south) ;;
    k|w|north|up)   wid=$(next_north) ;;
    l|d|east|right) wid=$(next_east)  ;;
    *)              usage             ;;
esac

test ! -z "$wid" && focus.sh "$wid"
