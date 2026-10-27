org 0x100
section .text

start:  
        mov ax, 0x13
        int 0x10
        mov ax, 0xA000
        mov es, ax
        xor bl, bl
        palette:
                mov dh, bl
                mov ch, bl
                mov cl, bl
                add bl, 32
                mov ax, 0x1010
                int 0x10
                inc bl
        jnz palette
l:      
        xor si, si
        mov cx, 64000
        draw:
               push dx
               xor dx, dx
               mov ax, si
               mov bx, 320
               div bx
               add ax, dx
               pop dx
               add ax, dx

               mov byte [es: si], al
               inc si      
        loop draw
        inc dx   
        in al, 0x60
        dec al   
jnz l   
mov ax, 3
int 0x10
ret  
