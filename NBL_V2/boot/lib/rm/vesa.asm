[bits 16]

set_vesa_mode:
    ; เตรียม segment registers
    push es
    push ds
    pusha

    ; ตั้งค่า ES=0 สำหรับ buffer
    xor ax, ax
    mov es, ax
    mov ds, ax

    ; --- ตรวจสอบ VESA support (AX=4F00h)
    mov ax, 0x4F00
    mov di, vesa_info
    int 0x10
    cmp ax, 0x004F
    jne vesa_failed

    ; --- ตรวจสอบโหมด 0x140 (AX=4F01h)
    mov ax, 0x4F01
    mov cx, 0x140         ; Mode 0x140: 1920x1080x32bpp
    mov di, mode_info
    int 0x10
    cmp ax, 0x004F
    jne vesa_failed

    ; --- เคลียร์หน้าจอก่อนเปลี่ยนโหมด
    mov ax, 0x0003
    int 0x10

    ; --- ตั้งโหมด VESA (AX=4F02h)
    mov ax, 0x4F02
    mov bx, 0x4140        ; LFB (0x4000) + Mode 0x140
    int 0x10
    cmp ax, 0x004F
    jne vesa_failed

    ; --- อ่าน Linear Framebuffer Address (แบบปลอดภัย)
    mov si, mode_info + 0x28
    mov eax, [si]          ; อ่าน 32-bit ในโหมด 16-bit (assembler จะเติม 66h prefix)
    mov [0x0500], eax

    mov si, ss_msg
    call print

    popa
    pop ds
    pop es
    ret

vesa_failed:
    mov si, err_msg
    call print
    cli
    hlt
    jmp $

; --- Buffers
vesa_info:
    times 256 db 0

mode_info:
    times 256 db 0

;lfb_ptr: dd 0