boot = ./boot
kernel = ./kernel
build = build

all:
	@mkdir -p $(build)
	# Build boot sector (512B)
	@nasm -f bin $(boot)/boot.asm -o $(build)/boot.bin
	
	# Build stage2 loader (10 sectors = 5120B)
	@nasm -f bin $(boot)/boot2.asm -o $(build)/boot2.bin
	
	# Build kernel and pad to exactly 4 sectors (2048B)
	@nasm -f bin $(boot)/kernel_entry.asm -o $(build)/kernel_temp.bin
	@dd if=/dev/zero of=$(build)/kernel.bin bs=512 count=4 2>/dev/null
	@dd if=$(build)/kernel_temp.bin of=$(build)/kernel.bin conv=notrunc 2>/dev/null
	
	# Create disk image with proper sector alignment
	@dd if=/dev/zero of=$(build)/os.bin bs=512 count=2048 2>/dev/null
	@dd if=$(build)/boot.bin of=$(build)/os.bin conv=notrunc bs=512 count=1 2>/dev/null
	@dd if=$(build)/boot2.bin of=$(build)/os.bin conv=notrunc bs=512 seek=1 count=10 2>/dev/null
	@dd if=$(build)/kernel.bin of=$(build)/os.bin conv=notrunc bs=512 seek=11 count=4 2>/dev/null
	
	@qemu-system-x86_64 -hda $(build)/os.bin -full-screen -vga std

d:
	@rm -rf ./build