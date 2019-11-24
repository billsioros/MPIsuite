#!/bin/bash

. ui.sh
. config.sh


REQUIRED=( OUTPUT_ROOT USER_ID COMPILER SCHEDULER MACRO VALUES TIME_PATTERN )

RESULTS="results.csv"

function max
{
    list=""

    for value in $*
    do
        list="$value, $list"
    done

    python -c "print(max([${list}]))"
}

if [ "$#" -lt 2 ]
then
    log "ERROR" "usage: $( basename "$0" ) [FILE] [DESCRIPTION]"; exit 1
fi

if [ ! -r "$1" ]
then
    log "ERROR" "'$1' is not readable"; exit 1
fi

if [ ! -r "$2" ]
then
    log "ERROR" "'$2' is not readable"; exit 1
fi

. "$2"

for value in "${REQUIRED[@]}"
do
    if [[ -z "${!value// }" ]]
    then
        log "ERROR" "'$value' has not been specified"; exit 1
    fi
done

exe="$( basename "$1" )"
exe="${exe%.*}.x"

DIR="$( date +"%d_%m_%Y" )/$( date +"%H_%M_%S" )"

for value in "${VALUES[@]}"
do
    if ! "$COMPILER" "$1" "$MACRO" "$value"
    then
        exit 1
    fi

    for ((processes = 1; processes <= 64; processes *= 2))
    do
        if ! "$SCHEDULER" "$exe" "$processes" "${DIR}/${value}/${processes}"
        then
            exit 1
        fi

        while true
        do
            running="$( qstat | grep "$USER_ID" )"

            if [ -z "$running" ]
            then
                break
            fi
        done
    done
done

find . -name "*job.sh" -delete

mkdir -p "${OUTPUT_ROOT}/${DIR}/mpiP"; mv *.mpiP  "${OUTPUT_ROOT}/${DIR}/mpiP"

declare -A measurements

for value in "${VALUES[@]}"
do
    for ((processes = 1; processes <= 64; processes *= 2))
    do
        for file in $( find "${OUTPUT_ROOT}/${DIR}/${value}/${processes}" -name "*.stdout" | tr '\n' ' ' )
        do
            values="$( cat "$file" | grep -Po "$TIME_PATTERN" | tr '\n' ' ' )"

            if [[ -z "${values// }" ]]
            then
                log "WARNING" "No matches for '${TIME_PATTERN}' in '$file'"

                if [[ ! -z "${EDITOR// }" ]] && [[ "$( command -v "$EDITOR" )" ]]
                then
                    "$EDITOR" "$EDITOR_ARGS" "$file" "${file%.*}.stderr"
                fi

                measurements["$value, $processes"]="-1"
            else
                measurements["$value, $processes"]="$( max "$values" )"
            fi
        done
    done
done

log "MESSAGE" "Saving measurements to '${OUTPUT_ROOT}/${DIR}/${RESULTS}'"

echo "${MACRO}, Processes, Time, Speed Up, Efficiency" > "${OUTPUT_ROOT}/${DIR}/${RESULTS}"

for value in "${VALUES[@]}"
do
    for ((processes = 1; processes <= 64; processes *= 2))
    do
        speedup="$( python -c "print(${measurements[$value, 1]} / ${measurements[$value, $processes]})" )"
        efficiency="$( python -c "print(${speedup} / ${processes})" )"

        echo "${value}, ${processes}, ${measurements[$value, $processes]}, ${speedup}, ${efficiency}"
    done
done >> "${OUTPUT_ROOT}/${DIR}/${RESULTS}"

if [[ ! -z "${EDITOR// }" ]] && [[ "$( command -v "$EDITOR" )" ]]
then
    "$EDITOR" "$EDITOR_ARGS" "${OUTPUT_ROOT}/${DIR}/${RESULTS}"
fi

