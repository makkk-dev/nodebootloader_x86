[bits 16]
enter_pm:
    cli                     ; ปิด interrupts
    
    ; โหลด GDT
    lgdt [gdt_descriptor]
    
    ; ตั้งค่า Protected Mode bit
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; กระโดดไปยังโค้ด 32-bit
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    cli
    ; ตั้งค่า segment registers ใหม่
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    ; Set stack to 0x80000 (512KB)
    mov esp, 0x80000      ; ตั้งค่า stack pointer

    cld
    mov esi, 0x90000     ; Source (temporary buffer)
    mov edi, 0x100000    ; Destination (1MB)
    mov ecx, 512         ; Copy 512 dwords (2048 bytes)
    rep movsd            ; Perform copy

    
    ;mov edi, 0xA0000      ; VRAM address สำหรับโหมด 13h ใน Protected Mode
    ;mov ecx, 320*200       ; จำนวนพิกเซลทั้งหมด
    ;mov al, 0x02           ; สีน้ำเงินอ่อน (ค่าสี 0x36 ใน VGA palette)
    ;rep stosb              ; เติมสีลงใน VRAM ทั้งหมด
    jmp CODE_SEG:0x100000
    ; หยุดการทำงาน
    jmp $
