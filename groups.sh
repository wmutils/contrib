#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL

usage() {
    echo "usage: $(basename $0) [-h] [-s wid group] [-m group] [-u group]"
    echo "       -h shows this help, you can also not provide args"
    echo "       -s sets WID's group"
    echo "       -m maps (shows) group"
    echo "       -u unmaps (hides) group"
    exit 1
}

# if no arguments are given
test $# -eq 0 && usage

# I suggest it's under /tmp or somewhere that gets cleaned up at reboot or gets
# cleaned up after X stops running
FSDIR=${FSDIR:-/tmp/groups.sh}

# groups dir doesn't exist
if [ ! -d $FSDIR ]; then
    # make dir to keep track of our stuff
    mkdir -p $FSDIR
    # file 'active' has a line for each visible group
    echo 'default' > $FSDIR/active
    # group.* is the file that keeps track of which window is in which group
    lsw > $FSDIR/group.default
fi

# define our functions

# sets wid ($1) given to it to the group given to it ($2)
set_group() {
}

# shows all the windows in group ($1) given to it
map_group() {
    # mapw -m WID
}

# hides all the windows in group ($1) given to it
unmap_group() {
    # mapw -u WID
}

# argument logic with getopts or whatever
