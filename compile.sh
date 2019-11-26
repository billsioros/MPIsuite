#!/bin/bash

. ui.sh


if [[ "$*" == *--clean* ]]
then
    find . -name "*.x" -delete; exit 0
fi

if [ "$#" -lt 1 ]
then
    log "ERROR" "usage: $( basename "$0" ) [SOURCE] [MACROS]..."; exit 1
fi

if [ ! -r "$1" ]
then
    log "ERROR" "'$1' is not readable"; exit 1
fi

exe="$( basename "$1" )"
exe="${exe%.*}.x"

args="-O3"

for ((key = 2; key <= $#; key += 2))
do
    value="$(( $key + 1))"

    if [ "$value" -gt "$#" ]
    then
        log "WARNING" "No value associated with key '${!key}'"
    else
        args="$args -D${!key}=${!value}"
    fi
done

if confirm "MESSAGE" "enable profiling"
then
    args="$args -g -L$MPIP_DIR/lib -lmpiP -lbfd -lunwind"
fi

if confirm "MESSAGE" "link OpenMP"
then
    args="$args -fopenmp"
fi

if ! mpicc $args "$1" -o "$exe" 2> /dev/null
then
    log "ERROR" "'$1' failed to compile"; exit 1
fi

