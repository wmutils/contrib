#!/bin/sh
#
# vxid - 2019 wtfpl
# Arrange windows on a virtual grid

GRDDIR=${GRDDIR:-/tmp/wmutils/grd}

WID=$(pfw)
ROOT=$(lsw -r)

GW=${GAP:-5}
SW=$(wattr w "$ROOT")
SH=$(wattr h "$ROOT")
BW=$(wattr b "$WID")

usage() {
	echo "Usage: $(basename "$0")
	gridder <init|move|resize> [x, y]"
	exit 1
}

set_id() {
	mkdir -p "$GRDDIR"
	echo "$GX $GY $PX $PY $SX $SY" > "$GRDDIR"/"$WID"
}

get_id() {
	set -f; set -- $(cat "$GRDDIR"/"$WID"); set +f;
	GX=$1 GY=$2 PX=$3 PY=$4 SX=$5 SY=$6
}

compute() {
	X=$((((SW-BW)*PX/GX)+GW))
	Y=$((((SH-BW)*PY/GY)+GW))
	W=$((((SW-BW)*SX/GX)-GW-GW-BW))
	H=$((((SH-BW)*SY/GY)-GW-GW-BW))
}

check_args() {
	if [ -z "$CX" ] || [ -z "$CY" ]; then
		usage
	fi
	if [ $((PX + SX + CX)) -gt "$GX" ] || [ $((PY + SY + CY)) -gt "$GY" ]; then
		exit 1
	fi
	if [ $((SX + CX)) -lt 1 ] || [ $((SY + CY)) -lt 1 ]; then
		exit 1
	fi
	if [ $((PX + CX)) -lt 0 ] || [ $((PY + CY)) -lt 0  ]; then
		exit 1
	fi
}

finalize() {
	set_id
	compute
	wtp $X $Y $W $H "$WID"
	exit 0
}

init() {
	GX=9; GY=9; PX=2; PY=2; SX=5; SY=5;
	finalize
}

resize() {
	CX="$1"
	CY="$2"
	get_id
	check_args
	SX=$((SX + CX))
	SY=$((SY + CY))
	finalize
}

move() {
	CX="$1"
	CY="$2"
	get_id
	check_args
	PX=$((PX + CX))
	PY=$((PY + CY))
	finalize
}

while [ $# -gt 0 ]; do
	case "$1" in
		-h) usage ;;
		init) init ;;
		move) move "$2" "$3" ;;
		resize) resize "$2" "$3" ;;
		*) usage ;;
	esac
done
