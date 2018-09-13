;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;; Copyright (c) 2018 Caio Gomes and Izabella Melo.                       ;;
;; source: https://github.com/minimarvin/infra-software)                  ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;; This file is part of a open educatio politics to allow everyone learn  ;;
;; how to build a bootloader. It's hardly inspired by a template          ;;
;; published by the monitors of the discipline of software infrastructure ;;
;; in Federal University of Pernambuco in the course of Computers         ;;
;; Engineering.                                                           ;;
;;                                                                        ;;
;; This program is free software: you can redistribute it and/or modify   ;;
;; it under the terms of the GNU General Public License as published by   ;;
;; the Free Software Foundation, version 3.                               ;;
;;                                                                        ;;
;; This program is distributed in the hope that it will be useful, but    ;;
;; WITHOUT ANY WARRANTY; without even the implied warranty of             ;;
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU       ;;
;; General Public License for more details.                               ;;
;;                                                                        ;;
;; You should have received a copy of the GNU General Public License      ;;
;; along with this program. If not, see <http://www.gnu.org/licenses/>.   ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defines                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
carriage_return equ 0Dh
write_service equ 0x0e
read_service equ 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Characters              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
space equ 0x20
endl equ 0x0A


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start Program           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org 0x500

bits 16                   ; 16 bits real mode

jmp 0x0000:start
start:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov ax, 0x7e0 ;0x50<<1 = 0x7e00 (início de kernel.asm)
    mov es, ax
    xor bx, bx   ;posição = es<<1+bx

	jmp load_kernel

load_kernel:
    mov ah, 02h ;lê um setor do disco
    mov al, 20  ;quantidade de setores ocupados pelo boot2
    mov ch, 0   ;track 0
    mov cl, 3   ;sector 2
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h

    jc load_kernel     ;se o acesso falhar, tenta novamente

    jmp 0x7e00   ;pula para o setor de endereco 0x500 (start do boot2)

end:
	jmp $


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subrountines            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

exit:
	times 510-($-$$) db 0 ;512 bytes
	dw 0xaa55             ;assinatura
