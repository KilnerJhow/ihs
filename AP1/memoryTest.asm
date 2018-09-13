org 0x7c00

global start

    section .data
memory: times 64 db 0
table: times 1 db 0

    section .bss

mem: resb 64

    section .text

start:
    mov cl, 0
    mov ax, 0
    mov ds, ax
    mov es, ax

    call findPos
    
    mov bx, table

    cmp ax, 0
    je axzero

    cmp ax, 1
    je axum




start1:
    call findPos

    cmp ax, 0
    je axzero1

    cmp ax, 1
    je axum1

    jmp exit

axum:

    mov al, 'u'
    mov ah, 0x0E
    int 10h

    mov al, 'm'
    int 10h

    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    jmp start1

axzero:

    mov al, 'z'
    mov ah, 0x0E
    int 10h

    mov al, 'e'
    int 10h

    mov al, 'r'
    int 10h

    mov al, 'o'
    int 10h

    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    jmp start1

axzero1:

    mov al, 'z'
    mov ah, 0x0E
    int 10h

    mov al, 'e'
    int 10h

    mov al, 'r'
    int 10h

    mov al, 'o'
    int 10h

    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    jmp exit

axum1:

    mov al, 'u'
    mov ah, 0x0E
    int 10h

    mov al, 'm'
    int 10h

    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    jmp exit

findPos:
    
    mov bx, table
    cmp bl, 00000001b
    jnz .op1

    cmp bl, 00000010b
    jnz .op2

    jmp .exit

    .op1:
        mov byte[bx], 00000001b
        
        mov ah, 0x0E
        mov al, '0'
        int 10h

        mov al, 0xA
        int 10h

        mov al, 0xD
        int 10h

        mov ax, 0
        jmp .exit
    
    .op2:
        mov byte[bx], 00000011b

        mov ah, 0x0E
        mov al, '1'
        int 10h

        mov al, 0xA
        int 10h

        mov al, 0xD
        int 10h

        mov ax, 1
    
    .exit:
        ret
    



vazio:
    mov al, 'v' ;o primeiro byte está vazio
    mov ah, 0x0E
    int 10h

exit:
    jmp exit


times 510 - ($-$$) db 0
dw 0aa55h