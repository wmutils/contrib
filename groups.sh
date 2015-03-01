#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL

usage() {
    cat << EOF
usage: $(basename $0) [-h] [-s wid group] [-m group] [-u group]"
       -h shows this help, you can also not provide args"
       -s sets WID's group"
       -m maps (shows) group"
       -u unmaps (hides) group"
EOF

    exit 1
}

# test for no arguments
test $# -eq 0 && usage

# I suggest it's under /tmp or somewhere that gets cleaned up at reboot or gets
# cleaned up after X stops running
FSDIR=${FSDIR:-/tmp/groups.sh}

# groups dir doesn't exist
if [ ! -d $FSDIR ]; then
    # make dir to keep track of our stuff
    mkdir -p $FSDIR
    # file 'active' has a line for each visible (mapped) group
    echo 'default' > $FSDIR/active
    # group.* is the file that keeps track of which window is in which group
    lsw > $FSDIR/group.default
fi

# define our functions

# assings WID ($1) to the group ($2)
set_group() {
    # delete WID from all the group files
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $FSDIR/group.*

    # insert WID into new group
    echo $1 >> $FSDIR/group.$2
}

# shows (maps) all the windows in group ($1)
map_group() {
    # safety
    if [ ! -f $FSDIR/group.$1 ]; then
        echo "Group doesn't exist"
        exit 1
    fi

    while read line; do
        mapw -m $line
    done < $FSDIR/group.$1
}

# hides (unmaps) all the windows in group ($1)
unmap_group() {
    # safety
    if [ ! -f $FSDIR/group.$1 ]; then
        echo "Group doesn't exist"
        exit 1
    fi

    while read line; do
        mapw -u $line
    done < $FSDIR/group.$1
}

# argument logic

while getopts "hs:m:u:" opt; do
    case $opt in
        h)
            usage
            ;;
        s)
            set_group $OPTARG \$$OPTIND # cool little trick here ;)
            ;;
        m)
            map_group $OPTARG
            ;;
        u)
            unmap_group $OPTARG
            ;;
    esac
done
