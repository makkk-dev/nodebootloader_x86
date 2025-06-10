[bits 16]
load_kernel:
    mov ah, 0x02
    mov al, KERNEL_SECTORS      ; 4 sectors
    mov ch, 0                   ; Cylinder 0
    mov cl, 2                   ; Sector 2
    mov dh, 0                   ; Head 0
    mov dl, 0x80                ; HDD
    mov bx, 0x9000              ; ES:BX = 0x9000:0x0000
    mov es, bx
    xor bx, bx
    int 0x13
    jc disk_error               ; ถ้า error กระโดด
    ret
disk_error:
    mov si, disk_error_msg
    call print
    jmp $