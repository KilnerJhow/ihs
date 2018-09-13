org 0x7c00

jmp 0x0000:start

    section .text

start:

    call clearscreen
    mov ax, 0
    mov si, ax
    mov di, ax
    mov ss, ax
    mov ds, ax
    mov es, ax

    call printWelcomeScreen

    call readOption

    call registerAcc

    mov si, memory
    call printString


after:

    ;call printString
    mov si, zero
    call printString
    jmp exit

debug: 
    ;debug
    mov ah, 0x0E
    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    mov al, 'o'
    int 10h

    mov al, 'k'
    int 10h

    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    ;end of debug
    ret

printWelcomeScreen:

    mov si, welcome
    call printString

    mov si, trace
    call printString

    mov si, option1
    call printString

    mov si, trace
    call printString

    mov si, option2
    call printString

    mov si, trace
    call printString

    mov si, option3
    call printString

    mov si, trace
    call printString

    mov si, option4
    call printString

    mov si, trace
    call printString

    mov si, option5
    call printString

    mov si, trace
    call printString

    mov si, option6
    call printString

    mov si, trace
    call printString

    ret



clearscreen:
    
    mov ah, 00h         ;Apaga o que estiver escrito na tela anteriormente
    mov al, 00h
    int 0x10

    mov al, 03h         ;Seta a tela para modo texto com 80x25
    mov ah, 0
    int 0x10

    ret

readOption:

    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0x01    ; Lê 20 caracteres
        je .loop        ; Caso a opção tenha sido escolhida, espera o enter ou backspace

        mov ah, 0x0E    ;função de printar um número na tela
        int 0x10

        push ax
        inc cl          ;incrementa a quantidade de teclas digitadas
        jmp .loop  

    .backspace:

        cmp cl, 0
        je .loop

        mov ah, 3
        int 0x10
        
        dec dl         ;usado para especificar a linha para remoção
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
        pop ax
        jmp .loop
    
    .done:
        
        pop ax

        cmp cl, 0
        je .loop        

        cmp al, 49      ;tecla 1
        je .option1

        cmp al, 50      ;tecla 2
        je .option2

        cmp al, 51      ;tecla 3
        je .option3

        cmp al, 52      ;tecla 4
        je .option4  

        cmp al, 53      ;tecla 5
        je .option5

        cmp al, 54      ;tecla 6
        je .option6     ;tecla 6

        
    .err:

        mov si, err
        call printString
        jmp .loop

    .option1:
        ;debug
        call debug
        ;end of debug

        ;call registerAcc
        ;call get_string
        mov ax, 1
        jmp .exit

    .option2:

    .option3:

    .option4:

    .option5:

    .option6:

    .exit:
        ret

registerAcc:

    call clearscreen
    mov si, insertName
    call printString
    mov dx, memory  ;movemos

    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0x14    ; Lê 20 caracteres para o nome
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

exit:

    mov ah, 0x0E
    mov al, 'E'
    int 10h

memory times 64 db 0  ; (48*5) Fazemos um array de 5 posições, onde cada uma possui 48 bytes de informação
;ex: [Nome][T][CPF][T][Ag][T][Conta][T][NewLine]
                            ; 20 - Nome + 1 Caractere terminador
                            ; 11 - CPF + 1 Caractere terminador
                            ; 5 - Agência + 1 Caractere terminador
                            ; 9 - Conta + 1 Caractere terminador

welcome db 'Bem vindo, selecione a opcao desejada abaixo', 0xA, 0xD, 0 ;0xA - New line, 0xD - Carriage Return, 0 - fim da string
option1 db '|Cadastrar conta:              1|', 0xA, 0xD, 0
option2 db '|Buscar conta:                 2|', 0xA, 0xD, 0
option3 db '|Editar conta:                 3|', 0xA, 0xD, 0
option4 db '|Deletar conta:                4|', 0xA, 0xD, 0
option5 db '|Listar agencias:              5|', 0xA, 0xD, 0
option6 db '|Listar contas de uma agencia: 6|', 0xA, 0xD, 0
trace   db '=================================', 0xA, 0xD, 0
insertName  db 'Insira seu nome:            ', 0xA, 0xD, 0
insertCPF   db 'Insira seu CPF:            ', 0xA, 0xD, 0
insertConta db 'Insira sua conta:            ', 0xA, 0xD, 0
insertAg    db 'Insira sua agencia:            ', 0xA, 0xD, 0
err     db '|Erro, opcao invalida           |', 0xA, 0xD, 0

zero db 'zero', 0xA, 0xD, 0


times 510-($-$$) db 0
dw 0aa55h