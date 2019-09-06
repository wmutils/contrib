#!/bin/sh
#
# fyr | 2019 (c) MIT
# wrapper around wmv to adjust window position

usage() {
    base="$(basename $0)"
    cat >&2 << EOF
Usage:
    $ $base up    | --up)    Move $JUMP pixels up.
    $ $base down  | --down)  Move $JUMP pixels down.
    $ $base left  | --left)  Move $JUMP pixels left.
    $ $base right | --right) Move $JUMP pixels right.
EOF

    test $# -eq 0 || exit $1
}

main() {
    JUMP=20

    case $# in
        1) wid="$(pfw)"              ;;
        2) widCheck "$2" && wid="$2" ;;
    esac

    case "$1" in
        up|--up)        wmv 0 -$JUMP $wid ;;
        down|--down)    wmv 0 +$JUMP $wid ;;
        left|--left)    wmv -$JUMP 0 $wid ;;
        right|--right)  wmv +$JUMP 0 $wid ;;
        -h|--help|help) usage 0           ;;
        *)              usage 1           ;;
    esac

    # move mouse to middle of window
    # wmp -a $(($(wattr x $wid) + $(wattr w $wid) / 2)) \
    #        $(($(wattr y $wid) + $(wattr h $wid) / 2))
}

main "$@"
