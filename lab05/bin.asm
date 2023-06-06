public print_bin
extrn number: word
extrn print_newline: near
extrn print_string: near

dseg segment para public 'DATA'
    bin_data db 16 dup(0), '$'
    output_bin_message db "Bin number: ", '$'
dseg ends

cseg segment para public 'CODE'

print_bin proc near
    mov ax, [number]
    mov cx, 15
print_bin_loop:
    mov bx, 2
    div bx

    mov bl, dl
    add bl, '0'
    mov si, cx
    lea si, [si + bin_data]
    mov [si], bl

    cmp cx, 0
    dec cx
    jne print_bin_loop

    lea si, bin_data
    mov [si], bl

    lea dx, output_bin_message
    call print_string
    lea dx, bin_data
    call print_string
    call print_newline
    ret
print_bin endp

cseg ends
end
