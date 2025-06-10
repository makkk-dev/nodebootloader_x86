[bits 16]
enter_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    cli
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x80000
    cld
    ; Copy kernel from 0x10000 to 0x100000
    mov esi, 0x10000
    mov edi, 0x100000
    mov ecx, 2048/4  ; 512 dwords = 2048 bytes
    rep movsd

    jmp CODE_SEG:0x100000