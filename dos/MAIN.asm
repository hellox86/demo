org 0x100

section .text
start:
	mov ax, 0x13
	int 0x10
	
	mov ax, 0xA000
	mov es, ax
	jmp loop
plot:
	push di
	push bx
	mov bx, ax
	shl ax, 6
	shl bx, 8
	add ax, bx
	pop bx
	add ax, bx
	mov di, ax
	
	mov byte [es:di], 0x0F
	pop di
	ret

line:
	
	ret
loop:	
	push ax
	push bx
	mov ax, 20
	mov bx, 20
	call plot
	pop bx
	pop ax

	in al, 0x60
	dec al

	jnz loop
 
text_mode:
	mov ax, 3 
	int 0x10 
	ret
