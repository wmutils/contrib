#! /bin/sh

# full screen to monitor
# usage: fsm <mon> <windowid>

usage () {
    echo "usage: $(basename $0) <disp> <wid>"
    exit 0
}



# Set the window given to full screen. 
# usage: set_full <monitor> <window> 
set_full () {
    local monitor=$1
    local window=$2
    wattr xywhi $window >$tempfile
    wtp $(geo_disp.sh $monitor) $window
    wtf $window
    chwb -s 0 $window
    chwso -r $window
}

# set the window given to full screen. 
# usage: set_full <monitor> <window> 
unset_full () {
    wtp $(cat ${tempfile})
    rm -f ${tempfile}
}

display=$1
windowid=$2
tempfile="/tmp/fs_data_$display"

# All them checks.
test -z "$1" && test -z "$2" && usage

# check if display is valid
ls_disp.sh | grep -q $display || usage

# check if windowid is valid
lsw | grep -q $windowid || usage

if [[ -f $tempfile ]]; then
    unset_full
else 
    set_full $display $windowid
fi

