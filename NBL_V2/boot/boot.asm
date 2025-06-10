[bits 16]
[org 0x7c00]

cli
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00      ; Set stack below bootloader

; Boot messages
mov si, boot_msg 
call print
mov si, boot_s2_msg
call print

; Load second stage to 0x0000:0x8000 (corrected ES)
mov ah, 0x02        ; BIOS read sector
mov al, 10          ; Sectors to read
mov ch, 0           ; Cylinder 0
mov cl, 2           ; Sector 2 (first sector after boot)
mov dh, 0           ; Head 0
mov dl, 0x80        ; Drive 0x80 (HDD)
mov bx, 0x8000      ; ES:BX = 0x0000:0x8000 (ES already 0)
int 0x13            ; Read sectors

jc load_failed      ; Jump on error

mov si, ss_msg      ; Success message
call print
jmp 0x0000:0x8000   ; Jump to second stage

load_failed:
    mov si, err_msg
    call print
    jmp $

%include "./boot/lib/rm/print.asm" ; 16-bit print routine

; Messages
boot_msg db "from boot : booting",0x0d,0x0a,0
boot_s2_msg db ">>boot stage 2 : video mode",0x0d,0x0a,0
err_msg db ">>failed",0x0d,0x0a,0
ss_msg db ">>success",0x0d,0x0a,0

; Boot signature
times 510 - ($ - $$) db 0
dw 0xAA55