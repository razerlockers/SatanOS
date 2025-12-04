all: satanos.img

boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

kernel.bin: kernel.asm gui.asm
	nasm -f bin kernel.asm -o kernel.bin

satanos.img: boot.bin kernel.bin
	dd if=/dev/zero of=satanos.img bs=512 count=2880
	dd if=boot.bin of=satanos.img conv=notrunc
	dd if=kernel.bin of=satanos.img bs=512 seek=1 conv=notrunc

run: satanos.img
	qemu-system-i386 -drive format=raw,file=satanos.img,if=floppy -no-reboot

clean:
	rm -f *.bin *.img

.PHONY: all run clean
