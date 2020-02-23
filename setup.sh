#!/bin/bash

. MPIs/mpis-ui

MPIS_DIR="MPIs"
MPISRC_PATH=".mpisrc"

if [[ "$*" == *--uninstall* ]]
then
    test -f ~/"${MPISRC_PATH}" && rm -vr ~/"${MPISRC_PATH}"
    test -d ~/bin/"${MPIS_DIR}" && rm -vr ~/bin/"${MPIS_DIR}"

    log "MESSAGE" "Consider removing any MPIs related entries from ~/.bashrc"

    exit 0
fi

mpirc_contents=\
"""#!/bin/bash

MPIS_DIR=~/bin/${MPIS_DIR}

export MPIS_COMPILER=\"\${MPIS_DIR}/mpis-compile\"

export MPIS_SCHEDULER=\"\${MPIS_DIR}/mpis-schedule\"

export MPIS_UI=\"\${MPIS_DIR}/mpis-ui\"

export MPIS_OUTPUT_ROOT=\"out\"

export MPIS_STDOUT_EXTENSION=\"stdout.log\"
export MPIS_STDERR_EXTENSION=\"stderr.log\"

export MPIS_CORES=8

export MPIS_USER_ID="$( whoami )"

export MPIS_EDITOR=\"code\"
export MPIS_EDITOR_ARGS=\"-wr\"

export PATH=\"\$MPIS_DIR\":\$PATH

module load mpiP
module load openmpi3
"""

bashrc_contents=\
"""
# MPIs
if [ -f ~/${MPISRC_PATH} ]; then
    . ~/${MPISRC_PATH}
fi
# MPIs
"""

MPISRC_PATH=~/"${MPISRC_PATH}"

log "MESSAGE" "Creating '${MPISRC_PATH}'"

if [[ ! -f "$MPISRC_PATH" ]] || confirm "WARNING" "Would you like to overwrite ${MPISRC_PATH}"
then
    echo -n "$mpirc_contents" > "$MPISRC_PATH"
fi

log "MESSAGE" "Adding MPIs to '~/.bashrc'"

echo -n "$bashrc_contents" >> ~/.bashrc

log "MESSAGE" "Installing MPIs in '~/bin/${MPIS_DIR}'"

mkdir -p ~/bin/"${MPIS_DIR}"; cp -r ./"${MPIS_DIR}" ~/bin/

chmod +x ~/bin/"${MPIS_DIR}"/mpis-compile
chmod +x ~/bin/"${MPIS_DIR}"/mpis-schedule
chmod +x ~/bin/"${MPIS_DIR}"/mpis-profile

log "MESSAGE" "Restart the terminal"
