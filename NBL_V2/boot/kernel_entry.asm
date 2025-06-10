[bits 32]
[org 0x100000]  ; Adjusted origin

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esp, 0xA0000  ; Stack at 640KB (safe)

; Get LFB pointer from 0x0500
mov eax, [0x0500]
mov [lfb_ptr], eax

; Paint screen RED
mov eax, 0x004CDB52  ; Corrected color (ARGB red)
mov edi, [lfb_ptr]
mov ecx, 1920*1080
rep stosd

lfb_ptr: dd 0
jmp $