#!/bin/sh
#
# wildefyr - 2015 (c) wtfpl
# find resolution of mpv video based on window id and resize

usage() {
    echo "usage: $(basename $0) <wid>"
    exit 1
}

# check wid exists
case $1 in
    0x*) wid=$1 ;;
    *) usage ;;
esac

# use xprop to find window class so we can be sure it's mpv we're resizing
widName=$(xprop -id $1 WM_CLASS | cut -f 4 -d \")

if [ $widName = 'mpv' ]; then
    resolution=$(xprop -id $(wid.sh mpv) WM_NORMAL_HINTS | sed '5s/[^0-9]*//p;d' | sed 's#/# #')
    wtp $(wattr xy $wid) $resolution $wid
fi
