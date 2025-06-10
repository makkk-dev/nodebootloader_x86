[org 0x7C00]
[bits 16]

KERNEL_SECTORS equ 10000

; ตั้งค่า segment registers
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00      ; ตั้ง stack pointer
    
; แสดงข้อความเริ่มต้น
mov si, boot_msg
call print
;load kernel
mov si, load_kernel_msg
call print
call load_kernel

mov si, vdm_msg
call print
call init_vdm

; เข้าสู่ Protected Mode
call enter_pm
    
; จุดนี้ไม่ควรมาถึงถ้าเข้าสู่ PM สำเร็จ
jmp $

; ข้อมูล
; Include files ที่ต้องใช้ก่อน

%include "./boot/kernel.asm"
%include "./boot/vdm.asm"
%include "./boot/gdt.asm"
%include "./boot/print.asm"
%include "./boot/pm.asm"

boot_msg db "from boot : booting",0x0d,0x0a,0
vdm_msg db ">>load vdm",0x0d,0x0a,0
vdm_error_msg db ">>load vdm error",0x0d,0x0a,0
load_kernel_msg db ">>load kernel",0x0d,0x0a,0
disk_error_msg db ">>load -fail",0x0d,0x0a,0

times 510-($-$$) db 0
dw 0xAA55