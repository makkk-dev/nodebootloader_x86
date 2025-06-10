boot = ./boot
kernel = ./kernel

all:
	@mkdir -p build
	@nasm -f bin $(boot)/boot.asm -o build/boot.bin
	@nasm -f bin $(kernel)/kernel.asm -o build/kernel.bin

	dd if=/dev/zero of=build/os.img bs=512 count=2880
	dd if=build/boot.bin of=build/os.img conv=notrunc
	dd if=build/kernel.bin of=build/os.img seek=2 conv=notrunc

	@qemu-system-x86_64 -hda build/os.img

d:
	@rm -rf build
