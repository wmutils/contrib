#!/bin/sh
# 
# Copyright (c) 2015 Laserswald, liscensed under the WTFPL
# Get the geometry of the given display.

## Function definitions.

usage () {
    echo "usage: $(basename $0) [-a] DISPLAY"
    exit 1
}

# Convert wonky Xrandr format to wmutils' format
dewonkify () {
    echo $3 $4 $1 $2
}

# Convert width and height coords to absolute coords
absolute () {
    w=$(( $1 + $3 ))
    h=$(( $2 + $4 ))
    echo $w $h $3 $4
}


# Parse them options. Do it.
while getopts a flag; do
    case $flag in 
        a) GIVE_ABS=1 ;;
        ?) usage ;;
    esac
done
shift $(( OPTIND - 1 ))

display=$1

# No given display? Ain't having that.
test -z $display && usage
rgeo=$(xrandr | grep -e "^$display connected" | cut -d " "  --field "3" | sed "s/[x\+]/ /g")

# Modify the dimensions if we want absolute coords or not
if [ $GIVE_ABS ] ; then 
    geo=$(absolute $rgeo)
else
    geo=$rgeo
fi

# Finally, echo the dewonkified geometry. Whew.
echo $(dewonkify $geo)
