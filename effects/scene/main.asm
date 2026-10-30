org 0x100
section .text

start:
	;; 320*200, 256 colors  
        mov ax, 0x13
        int 0x10
        mov ax, 0xA000
        mov es, ax
	jmp l

plot:
	push di
	push ax
	push dx
	mov dx, 320
	mul dx
	pop dx
	add ax, bx
	mov di, ax
	pop ax
	mov al, 0x0F
	stosb
	pop di	
	ret

l:
     	 
        in al, 0x60
        dec al   

jnz l
   
mov ax, 3
int 0x10
ret 
