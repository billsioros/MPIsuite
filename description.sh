#!/bin/bash

export MPIS_ENABLE_PROFILING=true
export MPIS_LINK_OPENMP=false

TIME_PATTERN="Elapsed time: \K([0-9]+\.[0-9]+)"

MACRO="nTraps"

VALUES=()

for ((power = 20; power <= 28; power += 2))
do
    VALUES+=( "$(( 2 << ($power - 1) ))" )
done
