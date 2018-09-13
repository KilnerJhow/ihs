org 0x7E00

jmp 0x0000:start

    section .text

start:

    call clearscreen

    mov ax, 0
    mov si, ax
    mov di, ax
    mov ds, ax
    mov es, ax

    call printWelcomeScreen

    call readOption

    mov si, memory
    call printString
    call new_line

    add si, 21
    call printString
    call new_line

    add si, 32
    call printString
    call new_line

    add si, 41
    call printString
    call new_line

    jmp start

new_line:

    mov ah, 0x0E
    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    ret

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

        cmp al, '1'      ;tecla 1
        je .option1

        cmp al, '2'     ;tecla 2
        je .option2

        cmp al, '3'     ;tecla 3
        je .option3

        cmp al, '4'      ;tecla 4
        je .option4  

        cmp al, '5'      ;tecla 5
        je .option5

        cmp al, '6'      ;tecla 6
        je .option6     ;tecla 6

        
    .err:
        
        call clearscreen
        call printWelcomeScreen
        mov si, err
        call printString
        jmp .loop

    .option1:
        
        call registerAcc
        jmp .exit

    .option2:

    .option3:

    .option4:

    .option5:

    .option6:

    .exit:
        ret

registerAcc:

    push ax
    push bx
    push cx

    call findPos        ;retorna em ax a posição de ínicio da conta

    mov di, memory      ;pega a base do vetor
    add di, ax          ;soma com o offset da conta

    call clearscreen
    mov si, insertName
    call printString
    call _insertName


    add di, 21
    call clearscreen
    mov si, insertCPF
    call printString
    call _insertCPF


    add di, 32
    call clearscreen
    mov si, insertConta
    call printString
    call _insertConta

    add di, 41
    call clearscreen
    mov si, insertAg
    call printString
    call _insertAg

    pop cx
    pop bx
    pop ax

    ret

_insertName:

    push ax
    push bx
    push cx

    mov cl, 0

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

        pop cx
        pop bx
        pop ax

        ret

_insertCPF:

    push ax
    push bx
    push cx

    mov cl, 0


    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0xB     ; Lê 11 caracteres para o CPF
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
        pop cx
        pop bx
        pop ax
        ret

_insertConta:

    push ax
    push bx
    push cx

    mov cl, 0


    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0x09     ; Lê 11 caracteres para a conta
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
        pop cx
        pop bx
        pop ax
        ret

_insertAg:

    push ax
    push bx
    push cx

    mov cl, 0


    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0x05     ; Lê 5 caracteres para a Ag
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
        pop cx
        pop bx
        pop ax
        ret

findPos:
    push bx

    mov bx, 0

    mov bl, tableOccuped

    cmp bl, 00000001b           ;Checamos se a pos está ocupada
    jnz .op1                    ;Se não estiver ocupada, a flag ZF não irá ser setada e ele irá pular para a condição

    cmp bl, 00000010b
    jnz .op2

    cmp bl, 00000100b
    jnz .op3

    cmp bl, 00001000b
    jnz .op4

    cmp bl, 00010000b
    jnz .op5

    jmp .cheio

    .op1:

        mov ax, 0
        jmp .exit
    
    .op2:

        mov ax, 48
        jmp .exit
    
    .op3:

        mov ax, 96
        jmp .exit
    
    .op4:

        mov ax, 144
        jmp .exit

    .op5
        mov ax, 192
        jmp .exit

    .cheio

        mov ax, 255

    .exit:

        pop bx
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

    jmp exit

    section .data

memory: times 240 db 0 ;reserva 240 bytes inicializado com 0
tableOccuped: times 1 db 0 ; tabela onde marcamos cada bit do byte como ocupado (1) ou não (0)

welcome:  db 'Bem vindo, selecione a opcao desejada abaixo', 0xA, 0xD, 0 ;0xA - New line, 0xD - Carriage Return, 0 - fim da string
option1:  db '|Cadastrar conta:              1|', 0xA, 0xD, 0
option2:  db '|Buscar conta:                 2|', 0xA, 0xD, 0
option3:  db '|Editar conta:                 3|', 0xA, 0xD, 0
option4:  db '|Deletar conta:                4|', 0xA, 0xD, 0
option5:  db '|Listar agencias:              5|', 0xA, 0xD, 0
option6:  db '|Listar contas de uma agencia: 6|', 0xA, 0xD, 0
trace:    db '=================================', 0xA, 0xD, 0
insertName:   db 'Insira seu nome:            ', 0xA, 0xD, 0
insertCPF:    db 'Insira seu CPF:            ', 0xA, 0xD, 0
insertConta:  db 'Insira sua conta:            ', 0xA, 0xD, 0
insertAg:     db 'Insira sua agencia:            ', 0xA, 0xD, 0
err:      db '|Erro, opcao invalida           |', 0xA, 0xD, 0


    section .bss

;memory: resb 240                ; reserva 240 bytes sem inicialização
;ex: [Nome][T][CPF][T][Ag][T][Conta][T][NewLine] 
                            ; 20 - Nome + 1 Caractere terminador
                            ; 11 - CPF + 1 Caractere terminador
                            ; 5 - Agência + 1 Caractere terminador
                            ; 9 - Conta + 1 Caractere terminador
; 20 - Nome
; 11 - CPF
; 5 - Ag
; 9 - Conta
