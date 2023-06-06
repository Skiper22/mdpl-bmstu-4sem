public input_number
extrn input_char: near
extrn number: word
extrn print_string: near

dseg segment para public 'DATA'
    input_number_message db "Input decimal number: ", '$'
dseg ends

cseg segment para public 'CODE'

input_number proc near
    lea dx, input_number_message
    call print_string
    xor bx, bx

input_number_loop:
    call input_char
    cmp al, 13
    je input_number_loop_end

    xor ah, ah
    sub al, 30h
    mov cx, ax
    mov ax, bx
    mov dx, 10
    mul dx
    add ax, cx
    mov bx, ax
    jmp input_number_loop
input_number_loop_end:
    mov [number], bx
    ret
input_number endp

cseg ends
end
