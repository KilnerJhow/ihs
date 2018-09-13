org 0x7c00

jmp start

buffer: times 64 db 0
memory: times 240 db 0
tableOccuped: times 5 db 0
cheio: db 'Banco de dados cheio', 0xA, 0xD, 0
poslivre: db 'Pos livre achada', 0xA, 0xD, 0
chamada:  db 'func chamada', 0xA, 0xD, 0
insertNumConta:  db 'Insira o num da conta:            ', 0xA, 0xD, 0
noAcc:  db 'Conta nao encontrada no banco de dados            ', 0xA, 0xD, 0
err:      db '|Erro, opcao invalida           |', 0xA, 0xD, 0
;debug string
naoigual: db 'Nao igual', 0xA, 0xD, 0
igual: db 'Igual', 0xA, 0xD, 0


start:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov di, tableOccuped

    mov al, 1
    stosb




    jmp exit

findAcc:
    
    push di
    push si
    push ax
    push cx

    mov si, insertNumConta
    call printString

    mov di, buffer
    call getConta

    mov cl, 0

    mov si, tableOccuped
    .loop:
        cmp cl, 5
        je .erro

        lodsb
        cmp al, '1'
        je .occupied

        inc cl

    .occupied:
        mov al, 48
        mul cl

    .compare:
        push si
        mov di, buffer

        mov si, buffer
        call printString

        mov si, memory
        add si, ax
        call printString

        mov si, memory
        add si, ax

        call strcmp

        jc .igual

    .n_igual:

        mov si, naoigual
        call printString
        pop si
        jmp .loop

    .igual:
        mov si, igual
        call printString
        jmp .exit

    .erro:
        mov si, noAcc
        call printString
        call waitEnter
    
    .exit:
        jmp .exit
        pop cx
        pop ax
        pop si
        pop di
        ret
    
printString:

    push ax             ;empilha reg para salva os valores anteriores
	push ds
	push cx

    mov cl, 0
    .loop:

        lodsb           ;carregamos em ax um byte, word ou dword apontado por DS:SI, (Data Segment):(Source Index), SI incrementa/decrementa automaticamente
        
        cmp cl, al      ;comparamos cl com al, seta flag ZF (Zero flag) para 1 caso operando iguais, 0 caso contrário
        jz .exit        ;caso al seja 0, chegamos ao final da string e podemos retornar
        
        mov ah, 0xE     ;função para printar um caracter na tela
        int 0x10        ;interrupção para printar um caracter na tela
        
        jmp .loop

    .exit:

        pop cx
        pop ds
        pop ax

        ret
getConta:
    push di
    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0x05     ; Lê 5 caracteres para a conta
        je .loop        ; Caso a opção tenha sido escolhida, espera o enter ou backspace

        mov ah, 0x0E    ;função de printar um número na tela
        int 0x10

        stosb
        inc cl          ;incrementa a quantidade de teclas digitadas
        jmp .loop  

    .backspace:

        cmp cl, 0
        je .loop

        dec di
        mov byte[di], 0

        mov ah, 3
        int 0x10
        
        dec dl          ;usado para especificar a linha para remoção
        mov ah, 2
        int 0x10

        mov al, ' '
        mov ah, 0x0E
        int 0x10

        mov ah, 3
        int 0x10
        
        dec dl          ;usado para especificar a linha para remoção
        mov ah, 2
        int 0x10
        
        dec cl
        jmp .loop

    .done:
        
        mov al, 0       ;salvar terminador de string
        stosb           ;salvamos o terminador de string na última posição apontada por di

        mov ah, 0x0E
        mov al, 0xA     ;nova linha e carriage return
        int 10h

        mov al, 0xD
        int 10h

    .exit:
        pop di
        ret
waitEnter:
    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 
    
        jmp .loop    
    .done:
        ret

strcmp:
    push ax
    push bx
    push di
    push si
    .loop:
        mov al, [si]   ; grab a byte from SI
        mov bl, [di]   ; grab a byte from DI
        cmp al, bl     ; are they equal?
        jne .notequal  ; nope, we're done.
        
        cmp al, 0  ; are both bytes (they were equal before) null?
        je .done   ; yes, we're done.
        
        inc di     ; increment DI
        inc si     ; increment SI
        jmp .loop  ; loop!
    
    .notequal:
        clc  ; not equal, clear the carry flag
        ret
        
    .done: 	
        stc  ; equal, set the carry flag
        pop si
        pop di
        pop bx
        pop ax
        ret

exit:
    jmp exit


times 510 - ($-$$) db 0
dw 0aa55h