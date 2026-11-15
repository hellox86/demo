org 0x100

x0 dw 0
y0 dw 0
x1 dw 0
y1 dw 0
dx1 dw 0
dy1 dw 0
err dw 0
sx dw 0
sy dw 0
	
section .text

start:
	mov ax, 0x13
	int 0x10
	mov ax, 0xA000
	mov es, ax
	jmp loop
plot:
	push ax
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
	pop ax
	ret

line:
	push ax
	push bx
	push cx
	push dx
	mov word [x0], ax
	mov word [x1], bx
	mov word [y0], cx
	mov word [y1], dx
	
	sub bx, ax
	jl .neg_sx
	mov word [sx], 1
	jmp .cx
.neg_sx:
	mov word [sx], -1
.cx:
	mov dx, bx
	sar dx, 15
	xor bx, dx
	sub bx, dx
	mov word [dx1], bx
	pop dx
	
	push dx
	sub dx, cx
	jl .neg_sy
	mov word [sy], 1
	jmp .cy
.neg_sy:
	mov word [sy], -1
.cy:
	mov ax, dx
	sar ax, 15
	xor dx, ax
	sub dx, ax
	neg dx
	mov word [dy1], dx

	add dx, word [dx1]
	mov word [err], dx
	
.loop:
	mov ax, word [y0]
	mov bx, word [x0]
	call plot
	cmp ax, word [y1]
	jne .s

	cmp bx, word [x1]
	jz .end
.s:
	mov cx, word [err]
	sal cx, 1
	cmp cx, word [dy1]
	jge .x
	cmp cx, word [dx1]
	jle .y
	jmp .loop
	
	
.x:
	mov ax, word [err]
	add ax, word [dy1]
	mov word [err], ax
	mov ax, word [x0]
	add ax, word [sx]
	mov word [x0], ax
	cmp cx, word [dx1]
	jle .y
	jmp .loop
.y:
	mov ax, word [err]
	add ax, word [dx1]
	mov word [err], ax
	mov ax, word [y0]
	add ax, word [sy]
	mov word [y0], ax
	jmp .loop
.end:
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	
loop:	
	pusha
	mov ax, 20
	mov bx, 20
	mov cx, 20
	mov dx, 40
	call line
	popa
	in al, 0x60
	dec al

	jnz loop
 
text_mode:
	mov ax, 3 
	int 0x10 
	ret
