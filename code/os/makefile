src=boot.s
obj=boot.o
elf=boot.elf
boot=boot.out
asm=boot.asm

boot.img:boot.s
	gcc -c -m32 $(src) -o  $(obj) 
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf) $(boot)
	objdump -S $(elf) > $(asm)
fat12:
	@dd if=/dev/zero of=$(boot) seek=1 count=2879 >> /dev/zero
	@ls -al $(boot)

run:$(asm)
	qemu-system-i386  -fda $(boot)

clean:
	rm -f $(obj) $(elf) $(boot) $(asm)
