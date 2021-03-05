#!/bin/sh

if [ -n "${1}" ] && [ -f "${1}/src/VMDApp.h" ]; then
    mkdir -p "$1"/lib
    git clone --depth=1 https://github.com/openmm/openmm.git "$1"/lib/openmm
    ln -s openmm/libraries/lepton "$1"/lib/lepton
else
    echo "ERROR: Please provide the location of the VMD source tree as argument."
    exit 1
fi
