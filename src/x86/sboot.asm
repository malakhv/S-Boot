;
; Copyright (C) 2022 Mikhail Malakhov <malakhv@gmail.com>
;
; This file is a part of S-Boot project.
;
; Confidential and Proprietary. All Rights Reserved.
; Unauthorized copying of this file, via any medium is strictly prohibited.
;

BITS 16     ; 16 bit mode
ORG 0x7C00  ; Program start (origin) address

;
; Code Segment
;
section .text

    jmp start

    ; Just a welcome message :)
    bootmsg  db "Welcome to S-Boot program!", 0

    ; Print routine
    print:
        lodsb
        or      al, al
        jz      printdone
        mov     ah, 0eh
        int     10h
        jmp     print
    printdone:
        ret

; Program entry point
start:
    
    xor     ax, ax
    mov     ds, ax
    mov     es, ax
    mov     si, bootmsg
    call    print

    cli
    hlt

mbr:
    times   510 - ($ - $$) db 0
    ; Boot signature (MBR)
    dw      0xAA55

; END
