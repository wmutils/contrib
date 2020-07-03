#!/bin/sh
#
# swallow
# fyr - 2020 (c) MIT

usage() {
    base=$(basename "$0")

    cat >&2 << EOF
Usage:
    $base "program" "arguments"
EOF

    [ $# -eq 0 ] || exit "$1"
}

main() {
    [ -z "$*" ] && usage 1

    # test first argument as a command and only proceed if it exists on $PATH
    if type "$1" > /dev/null 2>&1; then
        PFW="$(pfw)"
        mapw -u "$PFW"

        printf '%s\n' "$*" | ${SHELL:-"/bin/sh"}

        mapw -m "$PFW"
        focus.sh "$PFW"
    fi
}

main "$@"
