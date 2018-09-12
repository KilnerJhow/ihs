org 0x7c00

_start: 
    mov ax, 0
    mov ds, ax
    mov si, welcome ;movemos a posição de memória da msg para si, a fonte das operações de string
    mov cl, 0
    call printString
    jmp exit

printString:

    .loop:
        lodsb ;carregamos em ax um byte, word ou dword apontado por DS:SI, (Data Segment):(Source Index), SI incrementa/decrementa automaticamente
        cmp cl, al ;comparamos cl com al, seta flag ZF (Zero flag) para 1 caso operando iguais, 0 caso contrário
        je .exit ;
        mov ah, 0xE
        mov bh, 0
        int 0x10
        jmp .loop
    .exit:
        ret

exit:

welcome db 'Bem vindo, selecione a opcao desejada abaixo', 0xA, 0xD, 0 ;0xA - New line, 0xD - Carriage Return, 0 - fim da string
option1 db 'Cadastrar conta: 1', 0xA, 0xD, 0
option2 db 'Buscar conta: 2', 0xA, 0xD, 0
option3 db 'Editar conta: 3', 0xA, 0xD, 0
option4 db 'Deletar conta: 4', 0xA, 0xD, 0
option5 db 'Listar agencias: 5', 0xA, 0xD, 0
option6 db 'Listar contas de uma agencia: 6', 0xA, 0xD, 0

times 510 - ($-$$) db 0 ;
dw 0AA55h   ;Assinatura de bios
