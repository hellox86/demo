org 0x100 ;; Смещение 256 байт(DOS)
section .text

start:
    mov ax, 0x13 ;; 13 графический режим(320x200, 256 colors)
    int 0x10
    mov ax, 0xA000
    mov es, ax
    xor bl, bl
    palette: ;; меняю палитру
      mov dh, bl
      mov ch, bl
      mov cl, bl
      add dh, 16
      mov ax, 0x1010
      int 10h
      inc bl
    jnz palette

l:
    xor si, si 
    mov cx, 64000
    draw:
        push dx 
        mov dx, 0 ;; для деления
        mov ax, si
        mov bx, 320
        div bx
        sub ax, 100
        mov bx, ax

        ;; abs(x) = (x XOR y) - y
        sar bx, 15
        xor ax, bx
        sub ax, bx
         
        sub dx, 160
        mov bx, dx
        sar bx, 15
        xor dx, bx
        sub dx, bx

        add ax, dx
        pop dx
        add ax, dx
        mov byte [es:si], al
        inc si
    loop draw
    inc dx
    in al, 0x60 ;считываем с клавиатуры
    dec al ;если нажат ESC, то теперь al = 0

jnz l

mov ax, 0x3 ;текстовый режим
int 0x10 ;ставим текстовый режим
ret