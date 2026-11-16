org 0x100
	;;  Трюк с адресом видеобуфера (Mode 13h / VGA). Вместо того чтобы каждый раз прибавлять + 160 и + 100 к координатам каждой вершины, указатель на начало видеобуфера 0xA0000 сразу сдвигали в центр экрана: ptr = 0xA0000 + 100 * 320 + 160. После этого координаты проецировались по голой формуле x / z и y / z без сложений.
	
section .data
sintab 	dd 0, 1608, 3215, 4821, 6423, 8022, 9616, 11204, 12785, 14359, 15923, 17479, 19024, 20557, 22078, 23586, 25079, 26557, 28020, 29465, 30893, 32302, 33692, 35061, 36409, 37736, 39039, 40319, 41575, 42806, 44011, 45189, 46340, 47464, 48558, 49624, 50660, 51665, 52639, 53581, 54491, 55368, 56212, 57022, 57797, 58538, 59243, 59913, 60547, 61144, 61705, 62228, 62714, 63162, 63571, 63943, 64276, 64571, 64826, 65043, 65220, 65358, 65457, 65516, 65536 
	dd 65516, 65457, 65358, 65220, 65043, 64826, 64571, 64276, 63943, 63571, 63162, 62714, 62228, 61705, 61144, 60547, 59913, 59243, 58538, 57797, 57022, 56212, 55368, 54491, 53581, 52639, 51665, 50660, 49624, 48558, 47464, 46340, 45189, 44011, 42806, 41575, 40319, 39039, 37736, 36409, 35061, 33692, 32302, 30893, 29465, 28020, 26557, 25079, 23586, 22078, 20557, 19024, 17479, 15923, 14359, 12785, 11204, 9616, 8022, 6423, 4821, 3215, 1608, 0
	dd -1608, -3215, -4821, -6423, -8022, -9616, -11204, -12785, -14359, -15923, -17479, -19024, -20557, -22078, -23586, -25079, -26557, -28020, -29465, -30893, -32302, -33692, -35061, -36409, -37736, -39039, -40319, -41575, -42806, -44011, -45189, -46340, -47464, -48558, -49624, -50660, -51665, -52639, -53581, -54491, -55368, -56212, -57022, -57797, -58538, -59243, -59913, -60547, -61144, -61705, -62228, -62714, -63162, -63571, -63943, -64276, -64571, -64826, -65043, -65220, -65358, -65457, -65516, -65536 
	dd -65516, -65457, -65358, -65220, -65043, -64826, -64571, -64276, -63943, -63571, -63162, -62714, -62228, -61705, -61144, -60547, -59913, -59243, -58538, -57797, -57022, -56212, -55368, -54491, -53581, -52639, -51665, -50660, -49624, -48558, -47464, -46340, -45189, -44011, -42806, -41575, -40319, -39039, -37736, -36409, -35061, -33692, -32302, -30893, -29465, -28020, -26557, -25079, -23586, -22078, -20557, -19024, -17479, -15923, -14359, -12785, -11204, -9616, -8022, -6423, -4821, -3215, -1608

angle_u dd 4
angle dd 0

ynp dd 0
	
x0 dw 0
y0 dw 0
x1 dw 0
y1 dw 0
dx1 dw 0
dy1 dw 0
err dw 0
sx dw 0
sy dw 0
	
vs 	dd  -100,  -100, -100    
        dd 100,  -100, -100
        dd -100, -100, -100
 	dd 100, 100, -100
	
	dd  -100,  -100, 100    
        dd 100,  -100, 100   
        dd -100, -100, 100
 	dd 100, 100, 100


section .text
start:
	mov ax, 0x13
	int 0x10
	mov ax, 0xA000
	mov es, ax
	jmp loop
plot:
	push eax
	push edi
	push ebx
	mov ebx, eax
	shl eax, 6
	shl ebx, 8
	add eax, ebx
	pop ebx
	add eax, ebx
	mov edi, eax
	
	mov byte [es:edi], 0x0F
	pop edi
	pop eax
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

clear_scr:
	push di
	push cx
	push dx
	xor di, di
	mov cx, 64000
	rep stosb
	pop dx
	pop cx
	pop di
	ret

loop:
	call clear_scr
	pusha
	
	lea esi, [angle]
	
	mov eax, [angle_u]
	add eax, [esi]
	mov [esi], eax

	mov edi, eax
	and edi, 255

	lea esi, [sintab + edi*4]
	mov ebx, [esi]

	;; четверть круга 256
	add edi, 64
	and edi, 255
	mov eax, [sintab + edi*4]

	lea esi, [vs]

	mov ecx, [esi+4]
	mov dword [ynp], ecx
	imul ecx, eax
	mov edx, [esi+8]
	imul edx, ebx
	sub ecx, edx
	sar ecx, 16
	mov [esi+4], ecx

	mov ecx, [ynp]
	imul ecx, ebx
	mov edx, [esi+8]
	imul edx, eax
	add ecx, edx
	sar ecx, 16
	mov [esi+8], ecx	
	mov ecx, [esi]
	mov dword [ynp], ecx
	
	imul ecx, eax	
	mov edx, [esi+8]
	imul edx, ebx
	add ecx, edx
	sar ecx, 16	
	mov [esi], ecx
	
	mov ecx, [ynp]
	imul ecx, ebx
	neg ecx
	mov edx, [esi+8]
	imul edx, eax
	add ecx, edx
	sar ecx, 16
	mov [esi+8], ecx	

	mov eax, [esi]
	mov ebx, [esi+4]
	mov ecx, [esi+8]
	cdq
	idiv ecx
	add eax, 160
	mov edx, eax
	mov eax, ebx
	cdq
	idiv ecx
	mov ebx, eax
	add ebx, 100

	mov eax, edx

	mov edx, eax
	mov eax, ebx
	mov ebx, edx
	
	call plot
	popa	
	
	in al, 0x60
	dec al

	
	jnz loop
 
text_mode:
	mov ax, 3 
	int 0x10 
 	ret
