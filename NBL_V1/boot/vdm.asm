[bits 16]
init_vdm:
    mov ax, 0x0013              ; AH=00 (set mode), AL=13h (320x200)
    int 0x10
    jc video_error              ; ถ้า error กระโดด
    ret

video_error:
    mov si, vdm_error_msg
    call print

    cli
    hlt