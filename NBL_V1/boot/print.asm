[bits 16]
print:
    pusha
    mov ah, 0x0E           ; BIOS teletype function
.next_char:
    lodsb                  ; โหลดตัวอักษรต่อไป
    cmp al, 0
    je .done
    int 0x10               ; Call BIOS
    jmp .next_char
.done:
    popa
    ret
