#!/bin/sh

if [ -z "${2}" ] ; then
    echo "Usage: build_lepton.sh <path to VMD tree> <VMD arch>." >&2
    echo "" >&2
    echo "For example: " >&2
    echo "    ./add_lepton.sh ~/vmd-1.9.4 LINUXAMD64" >&2
    exit 1
fi

if [ -f "${1}/src/VMDApp.h" ]; then

    if ! grep -q LEPTON "${1}/configure" ; then
        patch -p1 < lepton.diff -d "${1}"
    fi

    mkdir -p "${1}"/lib

    if [ ! -d "${1}"/lib/lepton ] ; then
        echo "Trying to download Lepton via OpenMM repository"
        if ! git clone --depth=1 https://github.com/openmm/openmm.git "${1}"/lib/openmm ; then
            exit 1
        fi
        ln -s openmm/libraries/lepton "$1"/lib/lepton
    fi

    echo "Trying to build Lepton using CMake"
    mkdir -p "${1}/lib/lepton/lib_${2}"
    if hash cmake ; then
        cat > "${1}/lib/lepton/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.1)
project(Lepton)
file(GLOB LEPTON_SOURCES \${CMAKE_CURRENT_SOURCE_DIR}/src/[^.]*.cpp)
add_library(lepton STATIC \${LEPTON_SOURCES})
target_include_directories(lepton PRIVATE \${CMAKE_CURRENT_SOURCE_DIR}/include)
EOF
        if cd "${1}/lib/lepton/lib_${2}" ; then
            cmake -DCMAKE_CXX_STANDARD=11 --source ..
            cmake --build . --parallel $(nproc --all)
            cd ..
        fi
    fi

else

    echo "ERROR: Please provide the location of the VMD source tree as first argument."

    exit 1
fi
