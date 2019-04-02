#!/bin/sh
#
# vxid - 2019 wtfpl
# Arrange windows on a virtual grid

WID=$(pfw)
ROOT=$(lsw -r)

GW=${GAP:-5}
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)
BW=$(wattr b $WID)

usage() {
	echo "Usage: $(basename $0)
	gridder <init|move|resize> [x, y]"
	exit 1
}

set_id() {
	xprop -id $WID -f grid 8s -set grid "$GX $GY $PX $PY $SX $SY"
}

get_id() {
	ID=$(xprop -id $WID | grep 'grid' | cut -d '"' -f2)
	GX=$(echo $ID | awk '{print $1}')
	GY=$(echo $ID | awk '{print $2}')
	PX=$(echo $ID | awk '{print $3}')
	PY=$(echo $ID | awk '{print $4}')
	SX=$(echo $ID | awk '{print $5}')
	SY=$(echo $ID | awk '{print $6}')
}

compute() {
	X=$((((SW-BW)*PX/GX)+GW))
	Y=$((((SH-BW)*PY/GY)+GW))
	W=$((((SW-BW)*SX/GX)-GW-GW-BW))
	H=$((((SH-BW)*SY/GY)-GW-GW-BW))
}

check_args() {
	if [[ -z $CX || -z $CY ]]; then
		echo "Not enough arguments";
		exit 1
	fi
	if [[ -z $GX || -z $GY || -z $PX || -z $PY || -z $SX || -z $SY ]]; then
		exit 1
	fi
	if [[ $(($PX + $SX + $CX)) -gt $GX || $(($PY + $SY + $CY)) -gt $GY ]]; then
		exit 1
	fi
	if [[ $(($SX + $CX)) -lt 1 || $(($SY + $CY)) -lt 1  ]]; then
		exit 1
	fi
	if [[ $(($PX + $CX)) -lt 0 || $(($PY + $CY)) -lt 0  ]]; then
		exit 1
	fi
}

init() {
	GX=9
	GY=9
	PX=2
	PY=2
	SX=5
	SY=5
	set_id
	compute
	wtp $X $Y $W $H $WID
	exit 0
}

resize() {
	get_id
	check_args
	SX=$(($SX + $CX))
	SY=$(($SY + $CY))
	set_id
	compute
	wtp $X $Y $W $H $WID
	exit 0
}

move() {
	get_id
	check_args
	PX=$(($PX + $CX))
	PY=$(($PY + $CY))
	set_id
	compute
	wtp $X $Y $W $H $WID
	exit 0
}

while [ $# -gt 0 ]; do
	case "$1" in
		-h)
			usage
			;;
		init)
			init
			;;
		move)
			CX="$2"
			CY="$3"
			move
			;;
		resize)
			CX="$2"
			CY="$3"
			resize
			;;
		*)
			echo "Illegal argument $1"
			usage
			;;
	esac
done
