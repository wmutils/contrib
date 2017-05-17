#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# toggle mouse device - relies on xinput

ARGS="$@"

usage() {
    printf '%s\n' "usage: $(basename $0) <enable|disable|toggle>"
    test -z $1 && exit 0 || exit $1
}

getMouseDevice() {
    device=$(xinput | awk '/Mouse/ {printf "%s\n",$9}' | cut -d= -f 2)

    printf '%s\n' $device
}

getMouseStatus() {
    device=$(getMouseDevice)
    status=$(xinput list-props $device | awk '/Device Enabled/ {printf "%s\n", $NF}')

    printf '%s\n' $status
}

# move mouse to the middle of the given window
moveMouseEnabled() {
    wid=$1
    wmp -a $(wattr xy $wid)
    wmp -r $(($(wattr w $wid) / 2)) $(($(wattr h $wid) / 2))
}

# move mouse to bottom-right corner of the screen
moveMouseDisabled() {
    wmp $(wattr wh $(lsw -r))
}

enableMouse() {
    device=$(getMouseDevice)
    xinput set-int-prop $device "Device Enabled" $device 1
}

disableMouse() {
    device=$(getMouseDevice)
    moveMouseDisabled
    xinput set-int-prop $device "Device Enabled" $device 0
}

toggleMouse() {
    device=$(getMouseDevice)
    status=$(getMouseStatus)
    test "$status" -eq 1 && status=0 || status=1
    test "$status" -eq 1 && moveMouseEnabled $(pfw) || moveMouseDisabled
    xinput set-int-prop $device "Device Enabled" $device $status
}

main() {
    case $1 in
        e|enable)  enableMouse  ;;
        d|disable) disableMouse ;;
        t|toggle)  toggleMouse  ;;
        *)         usage        ;;
    esac
}

test -z "$ARGS" || main $ARGS
