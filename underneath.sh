#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# print window id directly underneath mouse

# fuck sh
intCheck() {
    test $1 -ne 0 2> /dev/null
    test $? -ne 2 || return 1
}

# find current mouse location or check input for XY coordinates
test $# -eq 0 && {
    pointerX="$(wmp | cut -d\  -f 1)"
    pointerY="$(wmp | cut -d\  -f 2)"
} || {
    intCheck $1 && pointerX=$1 || return 1
    intCheck $2 && pointerY=$2 || return 1
}

# start from the currently highest stacked window
for wid in $(lsw | tac); do
    windowX="$(wattr x $wid)"
    windowY="$(wattr y $wid)"

    # we won't get a match if the left and top edges are greater than X or Y
    test "$windowX" -gt "$pointerX" && continue
    test "$windowY" -gt "$pointerY" && continue

    windowW="$(wattr w $wid)"
    windowH="$(wattr h $wid)"

    # we won't get a match if the right and bottom edges are less than X or Y
    test "$((windowX + windowW))" -lt "$pointerX" && continue
    test "$((windowY + windowH))" -lt "$pointerY" && continue

    # print match!
    printf '%s\n' "$wid" 
    unset -v wid
    exit
done
