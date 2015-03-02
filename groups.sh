#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL

usage() {
    cat << EOF
usage: $(basename $0) [-h] [-s wid group] [-m group] [-u group]
       -h shows this help, you can also not provide args
       -s sets WID's group
       -m maps (shows) group
       -u unmaps (hides) group
EOF

    exit 1
}

# test for no arguments
test $# -eq 0 && usage

# I suggest it's under /tmp or somewhere that gets cleaned up at reboot or gets
# cleaned up after X stops running
FSDIR=${FSDIR:-/tmp/groups.sh}

# define our functions

# delete WID from all the group files
clean_wid() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $FSDIR/group.*
}

# assings WID ($1) to the group ($2)
set_group() {
    clean_wid $1

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

    # loop through group and map windows
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

    # loop through group and unmap windows
    while read line; do
        mapw -u $line
    done < $FSDIR/group.$1
}

# argument logic

# groups dir doesn't exist
if [ ! -d $FSDIR ]; then
    # make dir to keep track of our stuff
    mkdir -p $FSDIR
fi

# getopts yo
while getopts "hc:s:m:u:" opt; do
    case $opt in
        h)
            usage
            ;;
        c)
            clean_wid $OPTARG
            break
            ;;
        s)
            set_group $OPTARG $(eval echo "\$$OPTIND")
            break
            ;;
        m)
            map_group $OPTARG
            break
            ;;
        u)
            unmap_group $OPTARG
            break
            ;;
    esac
done
