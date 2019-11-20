#!/bin/bash

MACRO="nTraps"

VALUES=()

for ((power = 20; power <= 28; power += 2))
do
    VALUES+=( "$(( 2 << ($power - 1) ))" )
done

