#!/bin/sh
#Groups windows into workspaces. Stores the current workspace index in /tmp/workspaces/curr by default.

NUM_WS=9
WSDIR='/tmp/workspaces'

help() {
	cat << EOF
usage: $(basename $0) [-hinp] [-g ws_num] [-m ws_num] 
	-h: Displays this message
	-i: Initialize workspaces. Should be called once in a startup script.
	-n: Move up one workspace
	-p: Move down one workspace
	-g, <ws_num>: go to the workspace specified by <ws_num>
	-m, <ws_num>: move the currently focused window to the worskpace specified by <ws_num>
EOF
	exit 1
}
#initializes us in workspace 0
ws_init() {
	mkdir -p $WSDIR/
	i = 0
	while [ "$i" -le "$NUM_WS" ]; do
		:> $WSDIR/ws"$i"
		i=$(expr $i + 1)
	done
	echo 0 > $WSDIR/curr
}
#saves all of the workspaces 
save_ws() {
	curr=$(cat $WSDIR/curr);
	lsw > $WSDIR/ws"$curr";
}
move_to_ws() {
	ws_num=$1;
	if [ $ws_num -gt $NUM_WS ] || [ $ws_num -lt 0 ]; then
		echo "Workspace not found"
		return
	fi
	save_ws;
	mapw -u $(lsw)
	mapw -m $(cat $WSDIR/ws"$ws_num")
	echo $ws_num > $WSDIR/curr
}
next_ws() {
	#get what ws we're currently in
	curr=$(cat $WSDIR/curr);
	curr=$(expr $curr + 1);

	#take care of loopback
	if [ $curr -gt $NUM_WS ]; then
		curr=0;
	fi

	move_to_ws $curr;
}
prev_ws() {
	#get what ws we're currently in
	curr=$(cat $WSDIR/curr);
	curr=$(expr $curr - 1);

	#take care of loopback
	if [ $curr -lt 0 ]; then
		curr=$NUM_WS
	fi

	move_to_ws $curr;
}
move_focused_window() {
	wid=$(pfw);
	curr_ws=$(cat $WSDIR/curr);
	if [ $wid != curr_ws ]; then
		pfw >> $WSDIR/ws"$1";
		mapw -u $wid;
	fi
}
while getopts ":m:g:npi" opt; do
	case $opt in
		n)
			next_ws;;
		p)
			prev_ws;;
		g)
			move_to_ws $OPTARG;;
		m)
			move_focused_window $OPTARG;;
		i)
			ws_init;;
		\?)
			help;;
	esac
done
