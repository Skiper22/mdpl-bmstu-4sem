; заменить все цифры на заглавные латинские
; буквы с номерами в алфавите, соответствующими
; этим цифрам

dseg segment para public 'DATA'
	matrix db 9*9 dup(0)
    matrix_size db 0

    matrix_size_message db "input matrix size: ", 13, 10, '$'
	matrix_elements_message db "input matrix elements: ", 13, 10, '$'
	matrix_print_message db "result matrix: ", 13, 10, '$'
dseg ends

sseg segment para stack 'STACK'
	db 512 dup(?)
sseg ends

cseg segment para public 'CODE'
    assume ds:dseg, ss:sseg

; dx - string offset
print_string:
    push ax
    mov ah, 09h
    int 21h
    pop ax
    ret

; ax - symbol
print_char:
    push dx
    mov dl, al
    mov ah, 2h
    int 21h
    pop dx
    ret

; al - number char
print_number:
    add al, 30h
    call print_char
    ret

print_newline:
    push ax
	mov al, 13
	call print_char
	mov al, 10
	call print_char
    pop ax
	ret

input_size:
    call input_char
    sub al, 30h
    mov [matrix_size], al
    ret

; al - retval
input_char:
	mov ah, 01h
	int 21h
	ret

; input matrix
input_matrix:
    xor ax, ax
    lea si, matrix_size
    mov al, [si]
    mov di, ax

    xor bx, bx
input_matrix_row_loop:
    cmp bx, di
    je input_matrix_row_end

    xor cx, cx
input_matrix_col_loop:
    cmp cx, di
    je input_matrix_col_end

    ; loop body
    mov ax, 9
    mul bx

    mov si, ax
    mov bp, cx
    lea si, [bp + si + matrix]

    call input_char
    mov [si], al
    mov ax, 32
    call print_char
    ; body end

    inc cx
    jmp input_matrix_col_loop
input_matrix_col_end:
    call print_newline
    inc bx
    jmp input_matrix_row_loop
input_matrix_row_end:
    ret

; print matrix
print_matrix:
    xor ax, ax
    lea si, matrix_size
    mov al, [si]
    mov di, ax

    xor bx, bx
print_matrix_row_loop:
    cmp bx, di
    je print_matrix_row_end

    xor cx, cx
print_matrix_col_loop:
    cmp cx, di
    je print_matrix_col_end

    ; loop body
    mov ax, 9
    mul bx

    mov si, ax
    mov bp, cx
    lea si, [bp + si + matrix]

    mov al, [si]
    call print_char

    mov al, 32
    call print_char
    ; body end

    inc cx
    jmp print_matrix_col_loop
print_matrix_col_end:
    call print_newline
    inc bx
    jmp print_matrix_row_loop
print_matrix_row_end:
    ret

; process matrix
process_matrix:
    xor ax, ax
    lea si, matrix_size
    mov al, [si]
    mov di, ax

    xor bx, bx
process_matrix_row_loop:
    cmp bx, di
    je process_matrix_row_end

    xor cx, cx
process_matrix_col_loop:
    cmp cx, di
    je process_matrix_col_end

    ; loop body
    mov ax, 9
    mul bx

    mov si, ax
    mov bp, cx
    lea si, [bp + si + matrix]

    mov al, [si]
    mov ah, [si]
    sub ah, 30h
    cmp ah, 10
    jg not_digit

    add ah, 41h
    mov [si], ah
not_digit:
    ; body end

    inc cx
    jmp process_matrix_col_loop
process_matrix_col_end:
    inc bx
    jmp process_matrix_row_loop
process_matrix_row_end:
    ret

main:
    ; set data segment
    mov ax, dseg
    mov ds, ax

    ; read matrix size
    lea dx, matrix_size_message
    call print_string
    call input_size
    call print_newline

    ; input matrix
    lea dx, matrix_elements_message
    call print_string
    call input_matrix

    ; input matrix
    call process_matrix

    ; print matrix
    lea dx, matrix_print_message
    call print_string
    call print_matrix

    ; exit
    mov ax, 4c00h
    int 21h

cseg ends
end main
