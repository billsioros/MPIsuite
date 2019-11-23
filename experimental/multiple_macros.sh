#!/bin/bash

. ./description.sh

for values in "${VALUES[@]}"
do
    OLD_IFS="$IFS"; IFS=' ' read -r -a values <<< "$values"; IFS="$OLD_IFS"

    if [[ ! "${#MACROS[@]}" -eq "${#values[@]}" ]]
    then
        echo fuck; exit 1
    fi

    args="$(
        for (( i = 0; i <= "${#MACROS[@]}"; i++ ))
        do
            if [[ ! "$i" -eq "${#MACROS[@]}" ]]
            then
                echo -n "${MACROS[$i]} ${values[$i]} "
            else
                echo -n "${MACROS[$i]} ${values[$i]}"
            fi
        done
    )"

    echo "$args"
done

