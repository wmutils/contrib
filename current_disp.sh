#!/bin/sh
# Copyright © 2015 Laserswald. Liscensed under the WTFPL.
#
# Check if coordinates or a window is within the current display.
# Note: Currently only checks if the topleft corner is within the display.


usage () {
    echo "usage: $(basename $0) [-c X Y] [wid]"
    exit 1
}

ismon () {
    test "$1" -ge "$3" && test "$2" -ge "$4" && test "$1" -le "$5" && test "$2" -le "$6"
}

# Check each 
check_mon () {
    for mon in $(ls_disp.sh); do 
        if ismon $1 $2 $(geo_disp.sh -a $mon); then 
            echo $mon; 
        fi 
    done 
}

while getopts c flag; do
    case $flag in 
        c) COORDS=1 ;;
    esac
done

shift $(( $OPTIND - 1 ))

test -z "$1" && usage



if [ $COORDS ]; then
    check_mon $1 $2
else
    check_mon $(wattr xy $1) 
fi
