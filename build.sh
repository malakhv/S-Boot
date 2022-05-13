#!/bin/bash

#
# Copyright (C) 2022 Mikhail Malakhov <malakhv@gmail.com>
# 
# This file is a part of S-Boot project.
#
# Confidential and Proprietary. All Rights Reserved.
# Unauthorized copying of this file, via any medium is strictly prohibited.
#

#---------------------------------------------------------------------------------------------------
# The script is to build S-Boot and make image with it in MBR
# Author: Mikhail.Malakhov
#---------------------------------------------------------------------------------------------------

# The default out path
OUT_DIR=out

TARGET_ARCH=x86

COLOR_RED=`tput setaf 1`
COLOR_GREEN=`tput setaf 2`
COLOR_RESET=`tput sgr0`

# Print help
function script_help()
{
cat <<EOF
===================================================================
 This script include some commands to build S-Boot.
 
 To export all functions to your environment, please do:
    source build.sh
 
 And the following commands will be available:
    1 - build            : Build s-boot
    2 - make_image       : Make image file with S-Boot in MBR
    3 - build_all        : Build s-boot and make image file
                           with S-Boot in MBR

    5 - run_bochs        : Run the bochs emulator with generated
                           image file

    9 - clear            : Clear build environment
 
 You can call functions above directly (by number), for example:
    source build.sh 1

 Attention! You should call this script from
    the S-Boot source code dir!
===================================================================
EOF
    return 0;
}

# Clear build environment
function clear() {
    rm -Rf $OUT_DIR
}

# Setting up build environment
function env_setup() {
    local arch=x86
    if [ $1 ]; then
        arch=$1
    fi
    export TARGET_ARCH=$arch
    mkdir -p $OUT_DIR
}

# Build S-Boot
function build() {
    as src/$TARGET_ARCH/start.asm -o $OUT_DIR/sboot.o
    ld -Ttext 0x7c00 --oformat=binary $OUT_DIR/sboot.o -o $OUT_DIR/sboot.bin
}

# Make image file with S-Boot in MBR
function make_image() {
    dd if=/dev/zero of=$OUT_DIR/image.img bs=512 count=2880
    dd if=$OUT_DIR/sboot.bin of=$OUT_DIR/image.img
    echo "${COLOR_GREEN}Make boot image - done!${COLOR_RESET}"
}

# Build s-boot and make image file with S-Boot in MBR
function build_all {
    clear
    env_setup $1
    build
    make_image
}

# Run the bochs emulator with generated image file
function run_bochs() {
    local config="bochs/bochs.cfg"
    if [ $1 ]; then
        config=$1
    fi
    bochs -f $config
}


#---------------------------------------------------------------------------------------------------
# Script Entry Point
#---------------------------------------------------------------------------------------------------

func=$1

# Remove function number argument for pass
# params through call
shift

if [ ! "$func" ];then
    script_help

else
    if [ "$func" == "1" ];then
        env_setup "$@"
        build "$@"
    fi

    if [ "$func" == "2" ];then
        make_image "$@"
    fi

    if [ "$func" == "3" ];then
        build_all "$@"
    fi

    if [ "$func" == "5" ];then
        run_bochs "$@"
    fi

    if [ "$func" == "9" ];then
        clear "$@"
    fi
fi

func=$1

#---------------------------------------------------------------------------------------------------