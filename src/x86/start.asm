//
// Copyright (C) 2022 Mikhail Malakhov <malakhv@gmail.com>
//
// This file is a part of S-Boot project.
//
// Confidential and Proprietary. All Rights Reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited.
//

.code16                 # Using 16-bit code

.text                   # Code segment
    .globl _start;

//
// Programm Entry Point
//
_start:

    // Put your code here

_mbr:
    # Added MBR signature
    . = _start + 510     # Move to 510 byte from 0
    .byte 0x55
    .byte 0xaa

// END
