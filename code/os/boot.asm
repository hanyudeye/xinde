
boot.elf：     文件格式 elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	eb 4e                	jmp    7c50 <entry>
    7c02:	00 68 65             	add    %ch,0x65(%eax)
    7c05:	6c                   	insb   (%dx),%es:(%edi)
    7c06:	6c                   	insb   (%dx),%es:(%edi)
    7c07:	6f                   	outsl  %ds:(%esi),(%dx)
    7c08:	4f                   	dec    %edi
    7c09:	53                   	push   %ebx
    7c0a:	58                   	pop    %eax
    7c0b:	00 02                	add    %al,(%edx)
    7c0d:	01 01                	add    %eax,(%ecx)
    7c0f:	00 02                	add    %al,(%edx)
    7c11:	e0 00                	loopne 7c13 <start+0x13>
    7c13:	40                   	inc    %eax
    7c14:	0b f0                	or     %eax,%esi
    7c16:	09 00                	or     %eax,(%eax)
    7c18:	12 00                	adc    (%eax),%al
    7c1a:	02 00                	add    (%eax),%al
    7c1c:	00 00                	add    %al,(%eax)
    7c1e:	00 00                	add    %al,(%eax)
    7c20:	40                   	inc    %eax
    7c21:	0b 00                	or     (%eax),%eax
    7c23:	00 00                	add    %al,(%eax)
    7c25:	00 29                	add    %ch,(%ecx)
    7c27:	ff                   	(bad)  
    7c28:	ff                   	(bad)  
    7c29:	ff                   	(bad)  
    7c2a:	ff 6d 79             	ljmp   *0x79(%ebp)
    7c2d:	6f                   	outsl  %ds:(%esi),(%dx)
    7c2e:	73 75                	jae    7ca5 <my+0xe>
    7c30:	64 69 73 6b 20 20 66 	imul   $0x61662020,%fs:0x6b(%ebx),%esi
    7c37:	61 
    7c38:	74 31                	je     7c6b <puts+0x3>
    7c3a:	32 20                	xor    (%eax),%ah
    7c3c:	20 20                	and    %ah,(%eax)
	...

00007c50 <entry>:
    7c50:	b8 00 00 8e d8       	mov    $0xd88e0000,%eax
    7c55:	8e c0                	mov    %eax,%es
    7c57:	8e d0                	mov    %eax,%ss
    7c59:	bc 00 7c be 7c       	mov    $0x7cbe7c00,%esp
    7c5e:	7c e8                	jl     7c48 <start+0x48>
    7c60:	06                   	push   %es
    7c61:	00 be 97 7c e8 00    	add    %bh,0xe87c97(%esi)
	...

00007c68 <puts>:
    7c68:	8a 04 83             	mov    (%ebx,%eax,4),%al
    7c6b:	c6 01 3c             	movb   $0x3c,(%ecx)
    7c6e:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
    7c72:	0e                   	push   %cs
    7c73:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
    7c78:	eb ee                	jmp    7c68 <puts>

00007c7a <finish>:
    7c7a:	f4                   	hlt    
    7c7b:	c3                   	ret    

00007c7c <msg>:
    7c7c:	0d 0a 6d 79 20       	or     $0x20796d0a,%eax
    7c81:	62 6f 6f             	bound  %ebp,0x6f(%edi)
    7c84:	74 6c                	je     7cf2 <my+0x5b>
    7c86:	6f                   	outsl  %ds:(%esi),(%dx)
    7c87:	61                   	popa   
    7c88:	64                   	fs
    7c89:	65                   	gs
    7c8a:	72 20                	jb     7cac <my+0x15>
    7c8c:	69 73 20 72 75 6e 6e 	imul   $0x6e6e7572,0x20(%ebx),%esi
    7c93:	69 6e 67 00 0d 0a 77 	imul   $0x770a0d00,0x67(%esi),%ebp

00007c97 <my>:
    7c97:	0d 0a 77 65 6c       	or     $0x6c65770a,%eax
    7c9c:	63 6f 6d             	arpl   %bp,0x6d(%edi)
    7c9f:	65 20 74 6f 20       	and    %dh,%gs:0x20(%edi,%ebp,2)
    7ca4:	77 75                	ja     7d1b <my+0x84>
    7ca6:	6d                   	insl   (%dx),%es:(%edi)
    7ca7:	69 6e 67 73 20 6f 73 	imul   $0x736f2073,0x67(%esi),%ebp
    7cae:	20 00                	and    %al,(%eax)
	...
    7dfc:	00 00                	add    %al,(%eax)
    7dfe:	55                   	push   %ebp
    7dff:	aa                   	stos   %al,%es:(%edi)
