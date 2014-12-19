#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# window focus wrapper that sets borders and can focus next/previous window

# default values for borders
BW=${BW:-2}                    # border width
ACTIVE=${ACTIVE:-0xffffff}     # active border color
INACTIVE=${INACTIVE:-0x333333} # inactive border color

# get current window id
PFW=$(pfw)

ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)

usage() {
    echo "usage: $(basename $0) <next|prev|wid>"
    exit 1
}

setborder() {
    
    WW=$(wattr w $2)
    WH=$(wattr h $2)

    # do not modify border of fullscreen windows
    test $WW = $SW -a $WH = $SH && return

    case $1 in
        active)   chwb -s $BW -c $ACTIVE $2 ;;
        inactive) chwb -s $BW -c $INACTIVE $2 ;;
    esac
}

test -z "$1" && usage

case $1 in
    next) wid=$(lsw|grep -v $PFW|sed '1 p;d') ;;
    prev) wid=$(lsw|grep -v $PFW|sed '$ p;d') ;;
    *)    wattr $1 && wid=$1 ;;
esac

# exit we can't find another window to focus
test -z "$wid" && exit 1

# set inactive border on "old" window 
setborder inactive $PFW

setborder active $wid   # activate new window
chwso -r $wid           # put it on top of the stack
wtf $wid                # set focus on it
wmp -a $(wattr xy $wid) # move the mouse cursor to
wmp -r $(wattr wh $wid) # .. its bottom right corner
