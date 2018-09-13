org 0x7E00

jmp 0x0000:start

    section .text

start:

    ; call registerAcc

    call clearscreen

    mov ax, 0
    mov si, ax
    mov di, ax
    mov ds, ax
    mov es, ax

    call printWelcomeScreen

    .loop:

        call readOption

        cmp ax, 255
        je .cheio

        call clearscreen
        jmp start

    .cheio:
        call clearscreen
        call printWelcomeScreen
        mov si, cheio
        call printString
        jmp .loop

    ;usuário 1
    ; call new_line
    ; mov si, memory
    ; call printString
    ; call new_line

    ; mov si, memory
    ; add si, 21
    ; call printString
    ; call new_line

    ; mov si, memory
    ; add si, 32
    ; call printString
    ; call new_line

    ; mov si, memory
    ; add si, 39
    ; call printString
    ; call new_line

    ; call registerAcc

    ; ;usário 2
    ; call new_line
    ; mov si, memory
    ; add si, 48
    ; call printString
    ; call new_line

    ; mov si, memory
    ; add si, 69 ; 21 + 48
    ; call printString
    ; call new_line

    ; mov si, memory
    ; add si, 80  ;32 + 48
    ; call printString
    ; call new_line

    ; mov si, memory
    ; add si, 87;39 + 48
    ; call printString
    ; call new_line


    jmp exit


new_line:

    mov ah, 0x0E
    mov al, 0xA
    int 10h

    mov al, 0xD
    int 10h

    ret

printWelcomeScreen:
    push si

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

    pop si
    ret



clearscreen:
    
    push ax

    mov ah, 00h         ;Apaga o que estiver escrito na tela anteriormente
    mov al, 00h
    int 0x10

    mov al, 03h         ;Seta a tela para modo texto com 80x25
    mov ah, 0
    int 0x10

    pop ax
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

    .option1:   ;registrar conta
        
        call registerAcc
        jmp .exit

    .option2:   ;buscar conta

        call findAcc
        jmp .exit

    .option3:   ;editar conta

        ;call editAcc
        jmp .exit

    .option4:   ;deletar conta

        ;call delAcc
        jmp .exit

    .option5:   ;listar agencias

        ;call listAg
        jmp .exit

    .option6:   ;listar contas de uma agencia
        ;call listAgAcc
        jmp .exit

    .exit:
        ret

registerAcc:
   
    call findPos        ;retorna em ax a posição de ínicio da conta

    cmp ax, 255
    je .exit

    mov di, memory      ;pega a base do vetor
    add di, ax          ;soma com o offset da posição de memória onde vai ser salva

    call clearscreen
    mov si, insertName
    call printString
    call _insertName


    call clearscreen
    mov si, insertCPF
    call printString

    mov di, memory
    add di, ax         
    add di, 21
    call _insertCPF

    call clearscreen
    mov si, insertConta
    call printString

    mov di, memory
    add di, 32 ;32
    add di, ax         
    call _insertConta


    call clearscreen
    mov si, insertAg
    call printString

    mov di, memory
    add di, 39 ;41
    add di, ax         
    call _insertAg

    jmp .exit

    .cheio:

    .exit:
        ret 

findAcc:
    
    push di
    push si
    push ax
    push cx

    call clearscreen

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
        jmp .loop

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
_insertName:

    push ax
    push di

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

        pop di
        pop ax

        ret

_insertCPF:

    push ax
    push di

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
        pop di
        pop ax
        ret

_insertConta:

    push ax
    push di

    mov cl, 0

    .loop:
    
        mov ah, 0       ;função para pegar um dígito do teclado
        int 0x16        

        cmp al, 0x0D    ; valor do enter
        je .done        ; (je - Faz um jump caso o ZF = 1) 

        cmp al, 0x08    ;valor do backspace
        je .backspace   ;trata o backspace

        cmp cl, 0x05     ; Lê 11 caracteres para a conta
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
        pop ax
        ret

_insertAg:

    push ax
    push di

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
        pop di
        pop ax
        ret

findPos:
    push si
    push di
    push cx
    ;push dx

    mov cx, 0
    mov ds, cx
    mov es, cx
    mov si, tableOccuped
    mov di, tableOccuped
    .loop:
        cmp cx, 5
        je .cheio
    
        lodsb

        cmp al, 0
        je .posLivre
        
        inc cx
        jmp .loop

    .posLivre:

        cmp cx, 0
        je .op1

        cmp cx, 1
        je .op2

        cmp cx, 2
        je .op3

        cmp cx, 3
        je .op4

        cmp cx, 4
        je .op5



    .op1:

        mov al, '1'
        stosb

        mov ax, 0
        jmp .exit
    
    .op2:

        add di, cx
        mov al, '1'
        stosb

        mov ax, 48
        jmp .exit
    
    .op3:

        add di, cx
        mov al, '1'
        stosb

        mov ax, 96
        jmp .exit
    
    .op4:

        add di, cx
        mov al, '1'
        stosb
        
        mov ax, 144
        jmp .exit

    .op5:
    
        add di, cx
        mov al, '1'
        stosb
        
        mov ax, 192
        jmp .exit

    .cheio:

        mov ax, 255

    .exit:

        pop cx
        pop di
        pop si
        ret


printString:

    push ax             ;empilha reg para salva os valores anteriores
	push di
    push si

    mov cl, 0
    .loop:

        lodsb           ;carregamos em ax um byte, word ou dword apontado por DS:SI, (Data Segment):(Source Index), SI incrementa/decrementa automaticamente
        
        cmp cl, al      ;comparamos cl com al, seta flag ZF (Zero flag) para 1 caso operando iguais, 0 caso contrário
        jz .exit        ;caso al seja 0, chegamos ao final da string e podemos retornar
        
        mov ah, 0xE     ;função para printar um caracter na tela
        int 0x10        ;interrupção para printar um caracter na tela
        
        jmp .loop

    .exit:

        pop si
        pop di
        pop ax

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

    section .data
;{
memory: times 240 db 0 ;reserva 240 bytes inicializado com 0
;ex: [Nome][T][CPF][T][Ag][T][Conta][T][NewLine] 
                            ; 20 - Nome + 1 Caractere terminador
                            ; 11 - CPF + 1 Caractere terminador
                            ; 5 - Agência + 1 Caractere terminador
                            ; 9 - Conta + 1 Caractere terminador
tableOccuped: times 5 db 0 ; tabela onde marcamos cada bit do byte como ocupado (1) ou não (0)
buffer: times 64 db 0   ;buffer para armazernar dados temporários

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
insertNumConta:  db 'Insira o num da conta:            ', 0xA, 0xD, 0
noAcc:  db 'Conta nao encontrada no banco de dados            ', 0xA, 0xD, 0
cheio: db 'Banco de dados cheio', 0xA, 0xD, 0
err:      db '|Erro, opcao invalida           |', 0xA, 0xD, 0

;debug string
naoigual: db 'Nao igual', 0xA, 0xD, 0
igual: db 'Igual', 0xA, 0xD, 0

;}