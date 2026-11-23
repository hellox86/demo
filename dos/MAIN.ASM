org 0x100
start:
	mov ax, 0x13
	int 0x10
	mov ax, 0xA000
	mov es, ax
	
	jmp loop

loop:
	in al, 0x60
	dec al
	jnz loop
	

text_mode:	
	mov ax, 3 
	int 0x10
 	ret

