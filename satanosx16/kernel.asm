[BITS 16]
[ORG 0x7E00]

start:
    ; lol
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    
    ; i miss her
    call main_gui
    
    ; Hang if returned (yeah thing i will do to myself)
    jmp $

%include "gui.asm"
