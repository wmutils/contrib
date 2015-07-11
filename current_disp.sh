#!/bin/sh

usage () {
    echo "usage: $(basename $0) <wid>"
    exit 1
}

while getopts c flag; do
    case $flag in 
        c) COORDS=1 ;;
    esac
done

shift $(( $OPTIND - 1 ))

test -z "$1" && usage

ismon () {
    test "$1" -ge "$3" && test "$2" -ge "$4" && test "$1" -le "$5" && test "$2" -le "$6"
}

check_mon () {
    for mon in $(lm); do 
        if ismon $1 $2 $(mg -a $mon); then 
            echo $mon; 
        fi 
    done 
}

if [ $COORDS ]; then
    check_mon $1 $2
else
    check_mon $(wattr xy $1) 
fi
