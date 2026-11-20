org 0x100
	
section .data
sintab 	dd 0, 1608, 3215, 4821, 6423, 8022, 9616, 11204, 12785, 14359, 15923, 17479, 19024, 20557, 22078, 23586, 25079, 26557, 28020, 29465, 30893, 32302, 33692, 35061, 36409, 37736, 39039, 40319, 41575, 42806, 44011, 45189, 46340, 47464, 48558, 49624, 50660, 51665, 52639, 53581, 54491, 55368, 56212, 57022, 57797, 58538, 59243, 59913, 60547, 61144, 61705, 62228, 62714, 63162, 63571, 63943, 64276, 64571, 64826, 65043, 65220, 65358, 65457, 65516, 65536 
	dd 65516, 65457, 65358, 65220, 65043, 64826, 64571, 64276, 63943, 63571, 63162, 62714, 62228, 61705, 61144, 60547, 59913, 59243, 58538, 57797, 57022, 56212, 55368, 54491, 53581, 52639, 51665, 50660, 49624, 48558, 47464, 46340, 45189, 44011, 42806, 41575, 40319, 39039, 37736, 36409, 35061, 33692, 32302, 30893, 29465, 28020, 26557, 25079, 23586, 22078, 20557, 19024, 17479, 15923, 14359, 12785, 11204, 9616, 8022, 6423, 4821, 3215, 1608, 0
	dd -1608, -3215, -4821, -6423, -8022, -9616, -11204, -12785, -14359, -15923, -17479, -19024, -20557, -22078, -23586, -25079, -26557, -28020, -29465, -30893, -32302, -33692, -35061, -36409, -37736, -39039, -40319, -41575, -42806, -44011, -45189, -46340, -47464, -48558, -49624, -50660, -51665, -52639, -53581, -54491, -55368, -56212, -57022, -57797, -58538, -59243, -59913, -60547, -61144, -61705, -62228, -62714, -63162, -63571, -63943, -64276, -64571, -64826, -65043, -65220, -65358, -65457, -65516, -65536 
	dd -65516, -65457, -65358, -65220, -65043, -64826, -64571, -64276, -63943, -63571, -63162, -62714, -62228, -61705, -61144, -60547, -59913, -59243, -58538, -57797, -57022, -56212, -55368, -54491, -53581, -52639, -51665, -50660, -49624, -48558, -47464, -46340, -45189, -44011, -42806, -41575, -40319, -39039, -37736, -36409, -35061, -33692, -32302, -30893, -29465, -28020, -26557, -25079, -23586, -22078, -20557, -19024, -17479, -15923, -14359, -12785, -11204, -9616, -8022, -6423, -4821, -3215, -1608

angle_u dd 3	
angle dd 0

ynp dd 0
	
x0 dd 0
y0 dd 0
x1 dd 0
y1 dd 0
dx1 dd 0
dy1 dd 0
err dd 0
sx dd 0
sy dd 0
xp dd 0
yp dd 0
x dd 0
y dd 0
z dd 0
sinv dd 0
cosv dd 0
	
vs2:	times 16 dd 0

vs 	dd  -100,  -100, -100    
        dd 100,  -100, -100
        dd -100, 100, -100
 	dd 100, 100, -100
	
	dd  -100,  -100, 100    
        dd 100,  -100, 100   
        dd -100, 100, 100
 	dd 100, 100, 100

edges 	dd 0, 1
	dd 0, 2
	dd 1, 3
	dd 2, 3

	dd 4, 5
	dd 4, 6
	dd 5, 7
	dd 6, 7

	dd 0, 4
	dd 1, 5
	dd 2, 6
	dd 3, 7

	
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
	sal eax, 6
	sal ebx, 8
	add eax, ebx
	pop ebx
	add eax, ebx
	mov edi, eax
	
	mov byte [es:edi], 0x0F
	pop edi
	pop eax
	ret

line:
	push eax
	push ebx
	push ecx
	push edx
	mov dword [x0], eax
	mov dword [x1], ebx
	mov dword [y0], ecx
	mov dword [y1], edx
	
	sub ebx, eax
	jl .neg_sx
	mov dword [sx], 1
	jmp .cx
.neg_sx:
	mov dword [sx], -1
.cx:
	mov edx, ebx
	sar edx, 31
	xor ebx, edx
	sub ebx, edx
	mov dword [dx1], ebx
	pop edx
	
	push edx
	sub edx, ecx
	jl .neg_sy
	mov dword [sy], 1
	jmp .cy
.neg_sy:
	mov dword [sy], -1
.cy:
	mov eax, edx
	sar eax, 31
	xor edx, eax
	sub edx, eax
	neg edx
	mov dword [dy1], edx

	add edx, [dx1]
	mov dword [err], edx
	
.loop:
	mov eax, [y0]
	mov ebx, [x0]
	call plot
	cmp eax, [y1]
	jne .s

	cmp ebx, [x1]
	jz .end
.s:
	mov ecx, [err]
	sal ecx, 1
	cmp ecx, [dy1]
	jge .x
	cmp ecx, [dx1]
	jle .y
	jmp .loop
	
	
.x:
	mov eax, [err]
	add eax, [dy1]
	mov dword [err], eax
	mov eax, [x0]
	add eax, [sx]
	mov dword [x0], eax
	cmp ecx, [dx1]
	jle .y
	jmp .loop
.y:
	mov eax, [err]
	add eax, [dx1]
	mov dword [err], eax
	mov eax, [y0]
	add eax, [sy]
	mov dword [y0], eax
	jmp .loop
.end:
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

clear_scr:
	push ax
	push di
	push cx
	push dx
	xor di, di
	xor al, al
	mov cx, 64000
	rep stosb
	pop dx
	pop cx
	pop di
	pop ax
	ret

loop:
	push eax
	push esi
	push edi
	push ebx
	push edx
	call clear_scr
	
	lea esi, [angle]
	mov eax, [angle_u]
	add eax, [esi]
	mov [esi], eax

	mov edi, eax
	and edi, 255

	lea esi, [sintab + edi*4]
	mov ebx, [esi]
	mov [sinv], ebx
	
	;; четверть круга 256
	add edi, 64
	and edi, 255
	mov eax, [sintab + edi*4]
	mov [cosv], eax
	
	lea esi, [vs]
	lea edi, [vs2]
	
	mov ecx, 8
.loop:
	push ecx
	mov ecx, [esi+4]
	mov dword [ynp], ecx
	imul ecx, [cosv]
	mov edx, [esi+8]
	imul edx, [sinv]
	sub ecx, edx
	sar ecx, 16
	mov [y], ecx
 
	mov ecx, [ynp]
	imul ecx, [sinv]
	mov edx, [esi+8]
	imul edx, [cosv]
	add ecx, edx
	sar ecx, 16
	mov [z], ecx	
	mov ecx, [esi]
	mov dword [ynp], ecx
	
	imul ecx, [cosv]
	mov edx, [z]
	imul edx, [sinv]
	add ecx, edx
	sar ecx, 16	
	mov [x], ecx
	
	mov ecx, [ynp]
	imul ecx, [sinv]
	neg ecx
	mov edx, [z]
	imul edx, [cosv]
	add ecx, edx
	sar ecx, 16
	mov [z], ecx	
	
	mov eax, [x]
	mov ebx, [y]
	mov ecx, [z]
	add ecx, 1024
	sal eax, 8
	
	cdq
	idiv ecx
	add eax, 160
	mov [xp], eax

	mov eax, ebx
	sal eax, 8
	
	cdq
	idiv ecx
	add eax, 100
	mov [yp], eax
	
	mov ebx, [xp]

	mov [edi], ebx
	mov [edi+4], eax 
		
	add esi, 12
	add edi, 8
	
	pop ecx
	dec ecx
	jnz .loop

	lea edi, [vs2]
	lea esi, [edges]
	mov ecx, 12
.edj:
	push ecx
	mov ecx, [esi]
	mov edx, [esi+4]
	
	mov eax, [edi+ecx*8]
	mov ebx, [edi+edx*8]
	mov ecx, [edi+ecx*8 + 4]
	mov edx, [edi+edx*8 + 4]
	
	call line
	add esi, 8
	pop ecx
	dec ecx
	jnz .edj
	
	
	pop edx
	pop ebx
	pop edi
	pop esi
	pop eax
	in al, 0x60
	dec al
	jnz loop
	
text_mode:	
	mov ax, 3 
	int 0x10
 	ret
