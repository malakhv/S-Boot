org 0x510

section .text

start:
    mov ax,si
    add ax,10
    jmp ax

section .data
    db 0

section .mbr
    db 0x55
    db 0xAA

; END
