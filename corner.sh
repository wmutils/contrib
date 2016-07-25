#!/bin/sh
# cornerw - move a window to a corner

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

. $XDG_CONFIG_HOME/wmrc/globals
. $XDG_CONFIG_HOME/wmrc/disp

X=$SX
Y=$SY

case $1 in
  tr) X=$((SW + SX - WW - BWIDTH*2)) ;;
  bl) Y=$((SH + SY - WH - BWIDTH*2)) ;;
  br)
    X=$((SW + SX - WW - BWIDTH*2))
    Y=$((SH + SY - WH - BWIDTH*2))
    ;;
  md)
    X=$((SW/2 + SX - WW/2 - BWIDTH))
    Y=$((SH/2 + SY - WH/2 - BWIDTH))
    ;;
esac

wtp $X $Y $WW $WH $CUR
