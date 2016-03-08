#!/bin/sh
#
# wildefyr && greduan - 2016 (c) wtfpl
# groups script with usablity enchancements


ARGS="$@"
GROUPSDIR="~/path/to/tmp/directory"

usage() {
    cat << EOF
Usage: $(basename $0) [-a wid group] [-fc wid] [-shmtTuz group] [-rlhq]
    -a | --add:    Add a wid to a group, or clean it if it already exists in given group.
    -f | --find:   Outputs wid if it was not found in a group.
    -c | --clean:  Clean wid from all groups.
    -h | --hide:   Hide given group.
    -s | --show:   Show given group.
    -m | --map:    Show given group, but hide other active groups.
    -z | --cycle:  Cycle through windows in the given group.
    -t | --toggle: Toggle given group.
    -T | --smart:  Cycle through given group, or toggle it if only one window exists in group.
    -u | --unmap:  Unmap given group.
    -r | --reset:  Reset all groups.
    -l | --list:   List all groups.
    -q | --quiet:  Suppress all textual output.
    -h | --help:   Show this help.

I've left relevant focusing calls commented out, if you want this script to handle
focusing as well, try uncommenting the commands out to fit your preferences.
EOF

    test $# -eq 0 || exit $1
}

intCheck() {
    test $1 -ne 0 2> /dev/null
    test $? -ne 2 || {
         printf '%s\n' "'$1' is not an integer." >&2
         exit 1
    }
}

fnmatch() {
    case "$2" in
        $1) return 0 ;;
        *)  printf '%s\n' "Please enter a valid window id." >&2; exit 1 ;;
    esac
}

find_wid() {
    wid=$1
    fnmatch "0x*" "$wid"

    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        grep -q "$wid" "$group" && {
            printf '%s\n' "$group"
        }
    done
}

clean_wid() {
    cleanWid=$1

    # if it doesn't exist in a group, exit
    widInGroups=$(find_wid "$cleanWid")
    test -z "$widInGroups" && return 1

    mapw -m "$cleanWid"

    for group in $widInGroups; do
        buffer=$(grep -wv "$cleanWid" "$group")
        test -z "$buffer" 2> /dev/null && {
            cleanGroupNum=$(printf '%s\n' "$group" | rev | cut -d'.' -f 1 | rev)
            unmap_group "$cleanGroupNum" 2>&1 > /dev/null
        } || {
            printf '%s\n' "$buffer" > "$group"
        }
    done

    printf '%s\n' "$cleanWid cleaned!"
}

unmap_group() {
    unmapGroupNum=$1
    intCheck "$unmapGroupNum"

    test -f "$GROUPSDIR/group.${unmapGroupNum}" && {
        # make the group visible
        show_group "$unmapGroupNum"
        # clean group from active file
        buffer=$(grep -wv "$unmapGroupNum" "$GROUPSDIR/active")
        printf '%s\n' "$buffer" > "$GROUPSDIR/active"
        rm -f $GROUPSDIR/group.${unmapGroupNum}
        printf '%s\n' "group ${unmapGroupNum} cleaned!"
    } || {
        printf '%s\n' "group ${unmapGroupNum} does not exist!" >&2
    }
}

toggle_wid_group() {
    test ! -z $3 && usage 1

    addWid=$(printf "$1" | cut -d\  -f 1)
    addGroupNum=$(printf '%s' "$1" | cut -d\  -f 2)

    fnmatch "0x*" "$addWid"
    intCheck "$addGroupNum"

    test "$addWid" = "0x00000001" && {
        printf '%s\n' "Please enter a valid window id." >&2
        return 1
    }

    currentGroup=$(find_wid "$addWid")
    currentGroup=$(printf '%s\n' "$currentGroup" | rev | cut -d'.' -f 1 | rev)

    clean_wid "$addWid"

    test "$addGroupNum" -eq "$currentGroup" && {
        printf '%s\n' ""
        return 0
    }

    # hide wid if group is curently hidden
    test -f "$GROUPSDIR/inactive" && {
        while read -r inactive; do
            test "$inactive" -eq "$addGroupNum" && {
                mapw -u "$addWid"
                # test ! -z "$(lsw)" && {
                #     focusWid="$(lsw | tail -1)"
                #     focus.sh "$focusWid"
                # }
                break
            }
        done < $GROUPSDIR/inactive
    }

    # add group to active if group doesn't exist
    test ! -f "$GROUPSDIR/group.${addGroupNum}" && {
        printf '%s\n' "$addGroupNum" >> "$GROUPSDIR/active"
    }

    printf '%s\n' "$addWid" >> $GROUPSDIR/group.${addGroupNum}
    printf '%s\n' "$addWid added to ${addGroupNum}!"
}

hide_group() {
    hideGroupNum=$1
    intCheck "$hideGroupNum"

    printf '%s\n' "$hideGroupNum" >> "$GROUPSDIR/inactive"

    test -f "$GROUPSDIR/active" && {
        buffer=$(grep -wv "$hideGroupNum" "$GROUPSDIR/active")
        test ! -z "$buffer" && {
            printf '%s\n' "$buffer" > "$GROUPSDIR/active"
        } || {
            rm -f "$GROUPSDIR/active"
        }
    }

    while read -r addWid; do
        mapw -u $addWid
    done < $GROUPSDIR/group.${hideGroupNum}

    # test -z "$mapGroupNum" && {
    #     test ! -z "$(lsw)" && {
    #         focusWid="$(lsw | tail -1)"
    #         focus.sh "$focusWid"
    #     }
    # }

    printf '%s\n' "group ${hideGroupNum} hidden!"
}

show_group() {
    showGroupNum=$1
    intCheck "$showGroupNum"

    printf '%s\n' "$showGroupNum" >> "$GROUPSDIR/active"

    test -f "$GROUPSDIR/inactive" && {
        buffer=$(grep -wv "$showGroupNum" "$GROUPSDIR/inactive")
        test ! -z "$buffer" && {
            printf '%s\n' "$buffer" > "$GROUPSDIR/inactive"
        } || {
            rm -f "$GROUPSDIR/inactive"
        }
    }

    while read -r showWid; do
        mapw -m $showWid
    done < "$GROUPSDIR/group.${showGroupNum}"

    # focusWid=$(head -n 1 < "$GROUPSDIR/group.${showGroupNum}")
    # focus.sh "$focusWid"

    printf '%s\n' "group ${showGroupNum} visible!"
}

map_group() {
    mapGroupNum=$1
    intCheck "$mapGroupNum"

    test -f "$GROUPSDIR/active" && {
        # modifying the file while in a loop is bad, sh isn't that smart!
        cp "$GROUPSDIR/active" "$GROUPSDIR/.tmpactive"

        test -f "$GROUPSDIR/active" && {
            while read -r active; do
                test "$active" -eq "$mapGroupNum" && {
                    activeFlag=true
                    break
                }
            done < "$GROUPSDIR/active"

            test "$activeFlag" != "true" && {
                show_group "$mapGroupNum"
            } || {
                show_group "$mapGroupNum" > /dev/null
            }
        }

        while read -r active; do
            test "$mapGroupNum" -ne "$active" && {
                hide_group "$active"
            }
        done < "$GROUPSDIR/.tmpactive"

        rm "$GROUPSDIR/.tmpactive"
    } || {
        show_group "$mapGroupNum"
    }
}

toggle_group() {
    toggleGroupNum=$1
    intCheck "$toggleGroupNum"

    # find out if the group is active
    while read -r active; do
        test "$active" -eq "$toggleGroupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    test "$activeFlag" = "true" && {
        hide_group "${toggleGroupNum}"
    } || {
        show_group "$toggleGroupNum"

        # always place windows at the top of the window stack
        while read -r toggleWid; do
            chwso -r "$toggleWid"
            setborder.sh inactive "$toggleWid"
        done < "$GROUPSDIR/group.${toggleGroupNum}"

        # focus the top window in the group
        # focusWid=$(head -n 1 < "$GROUPSDIR/group.${toggleGroupNum}")
        # focus.sh "$focusWid"
    }
}

smart_toggle_group() {
    toggleGroupNum=$1
    intCheck "$toggleGroupNum"

    # find out if the group is active
    while read -r active; do
        test "$active" -eq "$toggleGroupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    # logic level over 9000
    test "$activeFlag" = "true" && {
        # focus single window in group, or if it is focused, hide it
        test $(wc -l < "$GROUPSDIR/group.${toggleGroupNum}") -eq 1 && {
            wid=$(cat $GROUPSDIR/group.${toggleGroupNum})
            test "$(pfw)" = $wid && {
                hide_group "${toggleGroupNum}"
                return 0
            }
            # || {
            #     focus.sh "$wid"
            #     return 0
            # }
        } || {
            # if more than one window, cycle through them
            while read -r wid; do
                test "$(pfw)" = $wid && {
                    cycle_group "$toggleGroupNum"
                    return 0
                }
            done < "$GROUPSDIR/group.${toggleGroupNum}"
        }
    } || {
        show_group "$toggleGroupNum"

        # always place windows at the top of the window stack
        while read -r wid; do
            chwso -r "$toggleWid"
            setborder.sh inactive "$toggleWid"
        done < "$GROUPSDIR/group.${toggleGroupNum}"

        # focus the top window in the group
        # focusWid=$(head -n 1 < "$GROUPSDIR/group.${toggleGroupNum}")
        # focus.sh "$focusWid"
    }
}

cycle_group() {
    cycleGroupNum=$1
    intCheck "$cycleGroupNum"

    while read -r active; do
        test "$active" -eq "$cycleGroupNum" && {
            activeFlag=true
            break
        }
    done < "$GROUPSDIR/active"

    test "$activeFlag" != "true" && {
        show_group "$cycleGroupNum"
    }

    # focusing the next window is essential here, so this is left uncommented
    wid=$(sed "0,/^${PFW}$/d" < $GROUPSDIR/group.${cycleGroupNum})
    test -z "$wid" && wid=$(head -n 1 < $GROUPSDIR/group.${cycleGroupNum})
    focus.sh "$wid"
}

reset_groups() {
    while read -r resetGroupNum; do
        test "$resetGroupNum" != "" && show_group "$resetGroupNum"
    done < "$GROUPSDIR/inactive"

    rm -f $GROUPSDIR/*
}

list_groups() {
    for group in $(find $GROUPSDIR/*.? 2> /dev/null); do
        printf '%s\n' "$(printf '%s' ${group} | rev | cut -d'/' -f 1 | rev):"
        printf '%s\n' "$(cat ${group})"
    done
}

main() {
    for arg in "$@"; do
        case "$arg" in -?|--*)   ADDFLAG=false ;; esac
        test "$ADDFLAG" = "true" && ADDSTRING="${ADDSTRING}${arg} "
        case "$arg" in -a|--add) ADDFLAG=true ;; esac
    done

    test ! -z "$ADDSTRING" && {
        toggle_wid_group "$ADDSTRING" && exit 0
    }

    for arg in "$@"; do
        test "$MAPFLAG"    = "true" && map_group "$arg"          && exit 0
        test "$SHOWFLAG"   = "true" && show_group "$arg"         && exit 0
        test "$HIDEFLAG"   = "true" && hide_group "$arg"         && exit 0
        test "$CYCLEFLAG"  = "true" && cycle_group "$arg"        && exit 0
        test "$CLEANFLAG"  = "true" && clean_wid "$arg"          && exit 0
        test "$UNMAPFLAG"  = "true" && unmap_group "$arg"        && exit 0
        test "$TOGGLEFLAG" = "true" && toggle_group "$arg"       && exit 0
        test "$SMARTFLAG"  = "true" && smart_toggle_group "$arg" && exit 0
        test "$FINDFLAG"   = "true" && {
            find_wid "$arg" && exit 0 || exit 1
            FINDFLAG=false
        }

        case "$arg" in
            -m|--map)    MAPFLAG=true    ;;
            -s|--show)   SHOWFLAG=true   ;;
            -h|--hide)   HIDEFLAG=true   ;;
            -f|--find)   FINDFLAG=true   ;;
            -c|--clean)  CLEANFLAG=true  ;;
            -u|--unmap)  UNMAPFLAG=true  ;;
            -z|--cycle)  CYCLEFLAG=true  ;;
            -t|--toggle) TOGGLEFLAG=true ;;
            -T|--smart)  SMARTFLAG=true  ;;
            -r|--reset)  reset_groups    ;;
            -l|--list)   list_groups     ;;
        esac
    done
}

test "$#" -eq 0 && usage 1

for arg in $ARGS; do
    case $arg in
        -q|--quiet)      QUIETFLAG=true ;;
        h|help-h|--help) usage 0        ;;
    esac
done

test "$QUIETFLAG" = "true" && {
    main $ARGS 2>&1 > /dev/null
} || {
    main $ARGS
}
