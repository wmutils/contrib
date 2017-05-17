#!/bin/sh
#
# canibaoxa/oxa (canibaoxa@gmail.com) - 2016 (c) wtfpl
#  thanks to neeasade for the logic pointers
#

# set the border color you would like here (hex rgb)
lbc=0xff0000

bspc subscribe node_focus node_flag | while read -a msg ; do
    [ "${msg[4]}" = "locked" -a "${msg[5]}" = "on" ] && chwb -c $lbc "${msg[3]}"  
break
done

while true ; do
    locked_win=$(bspc query -N -n .locked)
    chwb -c 0xff0000 $locked_win
done


