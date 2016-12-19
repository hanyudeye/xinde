src=head.s
obj=head.o
elf=head.elf
boot=kernel.out
asm=head.asm
address=

$(boot):$(src)
	gcc -c $(src) -m32 -o $(obj)
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)
	objdump -S $(elf) > $(asm)
clean: 
	-rm -f $(obj) $(elf) $(boot) $(asm)
