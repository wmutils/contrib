#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL

usage() {
    echo "usage: $(basename $0) <group> [<wid>]"
    exit 1
}

# if no arguments are given
test -z "$1" && usage

FSDIR=${FSDIR:-/tmp/groups}

# groups dir doesn't exist
if [ ! -d $FSDIR ]; then
    # make dir and put all the windows in a default group
    mkdir -p $FSDIR
    echo 'state:yes' >> $FSDIR/group.default
    lsw >> $FSDIR/group.default
fi

# mapw -m WID
# mapw -u WID
