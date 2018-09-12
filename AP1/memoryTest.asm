org 0x7c00

global start

    section .data
memory: times 64 db 0

    section .bss

mem: resb 64

    section .text

start:
    mov ax, 0
    mov si, ax
    mov di, ax

    ;lea di, [memory]
    ;lea di, [mem]
    mov di, mem

    mov al, 'A'
    stosb
    mov al, 'B'
    stosb
    mov al, 0
    stosb

    
    mov si, mem
    cmp byte[si], 0 ;primeiro byte vazio
    
    je vazio

    lodsb
    mov ah, 0x0E
    int 10h
    
    lodsb
    int 10h

    jmp loop


vazio:
    mov al, 'v'
    mov ah, 0x0E
    int 10h

loop:
    jmp loop

times 510 - ($-$$) db 0
dw 0aa55h