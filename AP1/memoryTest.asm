org 0x7c00

jmp start

memory: times 64 db 0

start:
    mov ax, 0
    mov si, ax
    mov di, ax

    lea di, [memory]

    mov al, 'A'
    stosb
    mov al, 'B'
    stosb
    mov al, 0
    stosb

    
    mov si, memory
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