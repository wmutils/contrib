#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# print window id directly underneath mouse

pointerX="$(wmp | cut -d\  -f 1)"
pointerY="$(wmp | cut -d\  -f 2)"

# start from the currently highest stacked window
for wid in $(lsw | tac); do
    windowX="$(wattr x $wid)"
    windowY="$(wattr y $wid)"

    # we know we won't get a match it if it's greater than X or Y
    test "$windowX" -gt "$pointerX" && continue
    test "$windowY" -gt "$pointerY" && continue

    windowW="$(wattr w $wid)"
    windowH="$(wattr h $wid)"

    # we know we won't get a match if the right and bottom edges are less than X or Y
    test "$((windowX + windowW))" -lt "$pointerX" && continue
    test "$((windowY + windowH))" -lt "$pointerY" && continue

    # print match!
    printf '%s\n' "$wid" && exit
done
