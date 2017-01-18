#!/bin/sh
# Constructs and groups windows into workspaces to switch between using your favorite keybinder.

NUM_WS=9

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
# Initializes us in workspace 0.
ws_init() {
	mkdir -p /tmp/workspaces/
	i=0
	while [ $i -le $NUM_WS ]; do
		:> /tmp/workspaces/ws"$i"
		i=$(expr $i + 1)
	done
	echo 0 > /tmp/workspaces/curr
}
# Saves all mapped windows to the current workspace.
save_ws() {
	curr=$(cat /tmp/workspaces/curr)
	lsw > /tmp/workspaces/ws"$curr"
}
move_to_ws() {
	ws_num=$1
	if [ $ws_num -gt $NUM_WS ] || [ $ws_num -lt 0 ]; then
		echo "Workspace not found"
		return
	fi
	curr_ws=$(cat /tmp/workspaces/curr);
	if [ $ws_num == $curr_ws ]; then
		# same workspace. ignore flicker
		return
	fi
	save_ws
	curr_windows=$(lsw)
	if [ "$curr_windows" ]; then
		mapw -u $(lsw)
	fi
	new_windows="$(cat /tmp/workspaces/ws$ws_num)"
	if [ "$new_windows" ]; then
		mapw -m $new_windows
	fi
	echo $ws_num > /tmp/workspaces/curr
}
next_ws() {
	# Get what ws we're currently in.
	curr=$(cat /tmp/workspaces/curr)
	curr=$(expr $curr + 1)

	# Take care of loopback.
	if [ $curr -gt $NUM_WS ]; then
		curr=0
	fi

	move_to_ws $curr
}
prev_ws() {
	# Get what ws we're currently in.
	curr=$(cat /tmp/workspaces/curr)
	curr=$(expr $curr - 1)

	# Take care of loopback.
	if [ $curr -lt 0 ]; then
		curr=$NUM_WS
	fi

	move_to_ws $curr
}
move_focused_window() {
	ws_num=$1
	if [ $ws_num -gt $NUM_WS ] || [ $ws_num -lt 0 ]; then
		echo "Workspace not found"
		return
	fi
	wid=$(pfw)
	curr_ws=$(cat /tmp/workspaces/curr);
	if [ $ws_num != $curr_ws ]; then
		pfw >> /tmp/workspaces/ws"$1"
		mapw -u $wid
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
