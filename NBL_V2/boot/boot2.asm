[bits 16]
[org 0x8000]

mov si, kernel_load_msg
call print

; Load kernel to 0x10000 (temporary buffer)
mov ah, 0x02
mov al, 4                   ; 4 sectors (2KB)
mov ch, 0                   ; Cylinder 0
mov cl, 12                  ; Sector 12 (after stage2)
mov dh, 0                   ; Head 0
mov dl, 0x80                ; HDD
mov bx, 0x1000              ; ES:BX = 0x1000:0x0000 (phys 0x10000)
mov es, bx
xor bx, bx
int 0x13
jc disk_error

mov si, load_vesa_msg
call print
call set_vesa_mode
call enter_pm
jmp $

disk_error:
    mov si, err_msg
    call print
    jmp $

%include "./boot/lib/rm/vesa.asm"
%include "./boot/lib/rm/print.asm"
%include "./boot/lib/rm/gdt.asm"
%include "./boot/lib/rm/pm.asm"

ss_msg db ">>success",0x0d,0x0a,0
err_msg db ">>failed",0x0d,0x0a,0
load_vesa_msg db ">>load vesa",0x0d,0x0a,0
kernel_load_msg db ">>loadkernel",0x0d,0x0a,0

times 5120 - ($-$$) db 0