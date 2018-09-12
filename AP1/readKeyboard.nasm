org 0x7c00

jmp _start
 
_start:

    mov cl, 0
    mov ah, 00h
    mov al, 00h
    int 0x10

    mov al, 03h
    mov ah, 0
    int 0x10


    .loop:
        mov ah, 0   ;função para pegar um dígito do teclado
        int 0x16   ; wait for keypress

        cmp al, 0x0D  ; enter pressed?
        je .done      ; yes, we're done

        cmp al, 0x08
        je .backspace

        cmp cl, 0x3F  ; 63 chars inputted?
        je .loop      ; yes, only let in backspace and enter

        mov ah, 0x0E    ;função de printar um número na tela
        int 0x10      ; print out character

        stosb  ; put character in buffer
        inc cl
        jmp .loop       

    .done:
        
        jmp exit

    .backspace:

        cmp cl, 0
        je .loop

        mov ah, 3
        int 0x10
        
        dec dl
        mov ah, 2
        int 0x10

        mov al, ' '
        mov ah, 0x0E
        int 0x10

        mov ah, 3
        int 0x10
        
        dec dl
        mov ah, 2
        int 0x10
        
        dec cl

        jmp .loop   


exit:

times 510 - ($ - $$) db 0
dw 0AA55h