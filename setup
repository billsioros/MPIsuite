#!/bin/bash

# Setting up aliases

alias rm='rm -riv'
alias mv='mv -iv'
alias cp='cp -riv'
alias lf='ls -bgoFcGh --group-directories-first'
alias start='xdg-open'
alias memory='ps axch -o cmd:15,%mem --sort=-%mem | head'

# Setting up the console's prompt

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]$PS1"

# Setting up MPI

module load openmpi3
module load mpiP

clear

