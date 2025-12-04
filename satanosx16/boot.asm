[BITS 16]
[ORG 0x7C00]

start:
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; i am the master of puppets by the way
    mov ax, 0x0003
    int 0x10

    ; IM FUCKED UP ALREADY
    mov ah, 0x02       
    mov al, 20          
    mov ch, 0           
    mov cl, 2           
    mov dh, 0           
    mov bx, 0x7E00      
    int 0x13
    jc disk_error

    ; Jump to kernel brutally
    jmp 0x7E00

disk_error:
    mov si, error_msg
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

error_msg db "Disk error! Press any key to reboot or just give up", 0

times 510-($-$$) db 0
dw 0xAA55
