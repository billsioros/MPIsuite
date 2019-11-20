#!/bin/bash

COMPILER="./compile.sh"

SCHEDULER="./schedule.sh"

OUTPUT_ROOT="out"

USER_ID="$( whoami )"

TIME_PATTERN="Elapsed time: \K([0-9]+\.[0-9]+)"

EDITOR="code"
EDITOR_ARGS="-wr"
