org 0x7c00  ;início do bootsector

call clearscreen
mov ax, 0
mov si, ax
mov di, ax
mov ss, ax
mov ds, ax

start:

    call readOption
    
    pop ax
    mov ah, 0x0E
    int 10h

    jmp exit







clearscreen:
    
    mov ah, 00h ; Apaga o que estiver escrito na tela anteriormente
    mov al, 00h
    int 0x10

    mov al, 03h ;Seta a tela para modo texto com 80x25
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

        cmp cl, 0x01    ; Lê apenas uma opção
        je .loop        ; Caso a opção tenha sido escolhida, espera o enter ou backspace

        mov ah, 0x0E    ;função de printar um número na tela
        int 0x10

        push ax         ;salvamos o o tipo escrito na pilha
        inc cl          ;incrementa a quantidade de teclas digitadas
        jmp .loop  

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
        pop ax
        jmp .loop
    
    .done:
        
        cmp cl, 0
        je .loop

        pop ax
        mov ah, 0x0E
        int 10h

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

        mov al, 'o'
        mov ah, 0x0E
        int 10h

        mov al, 'k'
        int 10h
        jmp exit

    .option2:

    .option3:

    .option4:

    .option5:

    .option6:

    .exit:
        ret

printString:

    mov cl, 0
    .loop:

        lodsb       ;carregamos em ax um byte, word ou dword apontado por DS:SI, (Data Segment):(Source Index), SI incrementa/decrementa automaticamente
        
        cmp cl, al  ;comparamos cl com al, seta flag ZF (Zero flag) para 1 caso operando iguais, 0 caso contrário
        jz .exit     ;caso al seja 0, chegamos ao final da string e podemos retornar
        
        mov ah, 0xE ;função para printar um caracter na tela
        int 0x10    ;interrupção para printar um caracter na tela
        
        jmp .loop

    .exit:
        ret

exit:


;memory TIMES  48*5  DB   0  ; Fazemos um array de 5 posições, onde cada uma possui 46bytes de informação
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
err     db '|Erro, opcao invalido           |', 0xA, 0xD, 0


times 510 - ($-$$) db 0 ;tamanho do código
dw 0AA55h   ;assinatura da bios