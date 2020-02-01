#!/bin/bash

. MPIs/mpis-ui

MPIS_DIR="MPIs"
BASHRC_PATH=".bashrc"
MPISRC_PATH=".mpisrc"

mpirc_contents=\
"""
export MPIS_DIR=~/bin/${MPIS_DIR}
export PATH=~/bin/$MPIS_DIR:\$PATH

. ~/bin/${MPIS_DIR}/.mpis.config

module load mpiP
module load openmpi3
"""

bashrc_contents=\
"""
# setting up MPIs
if [ -f ~/${MPISRC_PATH} ]; then
    . ~/${MPISRC_PATH}
fi
# setting up MPIs
"""

log "MESSAGE" "Creating '~/${MPISRC_PATH}'"

if [[ ! -f ~/"$MPISRC_PATH" ]] || confirm "WARNING" "Would you like to overwrite ${MPIRC_PATH}"
then
    echo -n "$mpirc_contents" > ~/"$MPISRC_PATH"
fi

log "MESSAGE" "Adding MPIs to '~/${BASHRC_PATH}'"

echo -n "$bashrc_contents" >> ~/"$BASHRC_PATH"

log "MESSAGE" "Installing MPIs in '~/bin/${MPIS_DIR}'"

mkdir -p ~/bin/"${MPIS_DIR}"; cp -r ./"${MPIS_DIR}" ~/bin/

log "MESSAGE" "Done"

log "MESSAGE" "Consider re-opening the terminal"
