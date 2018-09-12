org 0x7c00

mov ax, 0
mov ds, ax
mov al, 'b'
mov cl, 0
mov bx, memory

mov ah, 0Eh
int 10h

mov byte [bx], al
inc bx
mov al, 'f'
int 10h

mov byte [bx], al

dec bx
mov al, byte[bx]
mov ah, 0Eh
int 10h

inc bx
mov al, byte[bx]
mov ah, 0Eh
int 10h



memory TIMES 32 db 0

times 510 - ($ - $$) db 0
dw 0AA55h