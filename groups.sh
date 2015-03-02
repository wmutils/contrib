#!/bin/sh
#
# Copyright (c) 2015 Greduan <me@greduan.com>, licensed under the WTFPL

usage() {
    cat << EOF
usage: $(basename $0) [-h] [-k wid] [-s wid group] [-t group] [-m group] [-u group]
       -h shows this help
       -c clean wid from group files and kill
       -s sets WID's group
       -t toggle group visibility state
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

# clean WID ($1) from group files and kill WID
clean_wid() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $FSDIR/group.*

    killw $1
}

# cleans group ($1) from (in)active files
clean_status() {
    # TODO: make POSIX compatible, -i is a GNU-ism
    sed -i "/$1/d" $FSDIR/active
    sed -i "/$1/d" $FSDIR/inactive
}

# assings WID ($1) to the group ($2)
set_group() {
    clean_wid $1

    # insert WID into new group
    echo $1 >> $FSDIR/group.$2

    # clean statuses
    clean_status $2
    # add to active
    echo $2 >> $FSDIR/active
}

# shows (maps) all the windows in group ($1)
map_group() {
    # safety
    if [ ! -f $FSDIR/group.$1 ]; then
        echo "Group doesn't exist"
        exit 1
    fi

    # clean statuses
    clean_status $1
    # add to active
    echo $1 >> $FSDIR/active

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

    # clean statuses
    clean_status $1
    # add to inactive
    echo $1 >> $FSDIR/inactive

    # loop through group and unmap windows
    while read line; do
        mapw -u $line
    done < $FSDIR/group.$1
}

# toggles visibility state of all the windows in group ($1)
toggle_group() {
    # search through active groups first
    grep -q $1 < $FSDIR/active && \
    unmap_group $1 && \
    return

    # search through inactive groups next
    grep -q $1 < $FSDIR/inactive && \
    map_group $1 && \
    return

    # if we're still here it means it couldn't find it in either
    # in which case we'll map it by default
    map_group $1
}

# argument logic

# getopts yo
while getopts "hk:s:t:m:u:" opt; do
    # groups dir doesn't exist
    if [ ! -d $FSDIR ]; then
        # make dir to keep track of our stuff
        mkdir -p $FSDIR
    fi

    # TODO: optimize this
    if [ ! -f $FSDIR/active ]; then
        touch $FSDIR/active
    fi
    if [ ! -f $FSDIR/inactive ]; then
        touch $FSDIR/inactive
    fi

    case $opt in
        h)
            usage
            ;;
        k)
            clean_wid $OPTARG
            break
            ;;
        s)
            set_group $OPTARG $(eval echo "\$$OPTIND")
            break
            ;;
        t)
            toggle_group $OPTARG
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
