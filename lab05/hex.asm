public print_hex
extrn number: word
extrn print_newline: near
extrn print_string: near

dseg segment para public 'DATA'
    hex_data db 5 dup(0), '$'
    output_hex_message db "Hex number: ", '$'
dseg ends

cseg segment para public 'CODE'

print_hex proc near
    lea si, hex_data
    mov bl, '+'
    mov [si], bx

    mov cx, 4

    mov ax, [number]
    cmp ax, 32768

    jae negative
    jmp print_hex_loop
negative:
    lea si, hex_data
    mov bl, '-'
    mov [si], bx
    mov bx, ax
    sub bx, 32768
    mov ax, bx
    jmp print_hex_loop

print_hex_loop:
    mov bx, 16
    div bx

    mov bl, dl

    cmp bl, 9
    jg letter

    add bl, '0'
    jmp write_digit
letter:
    add bl, 'A'
    sub bl, 10
write_digit:
    mov si, cx
    lea si, [si + hex_data]
    mov [si], bl

    cmp cx, 1
    dec cx
    jne print_hex_loop

    lea dx, output_hex_message
    call print_string
    lea dx, hex_data
    call print_string
    call print_newline
    ret
print_hex endp

cseg ends
end
