[bits 32]
[org 100000]

; Initialize segment registers with data selector (0x10)

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax
mov esp, 0x90000     ; Set stack to 576KB (safe location)

mov edi, 0xA0000      ; VRAM address สำหรับโหมด 13h ใน Protected Mode
mov ecx, 320*200       ; จำนวนพิกเซลทั้งหมด
mov al, 0x02          ; สีน้ำเงินอ่อน (ค่าสี 0x36 ใน VGA palette)
rep stosb              ; เติมสีลงใน VRAM ทั้งหมด

jmp $