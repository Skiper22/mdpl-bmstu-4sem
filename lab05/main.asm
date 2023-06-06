; ввод - беззнаковое в 10 с/с
; вывод1 - беззнаковое в 2 с/с
; вывод2 - знаковое в 16 с/с

public number
public print_newline
public input_char
public print_digit
public print_string
extrn input_number: near
extrn print_bin: near
extrn print_hex: near

dseg segment para public 'DATA'
    number dw 0
    jump_index db 0
    jump_table dw exit, input_number, print_bin, print_hex

    menu_message db "Menu: ", 13, 10, '$'
    menu_item0_message db "0. Quit", 13, 10, '$'
    menu_item1_message db "1. Input  number (unsigned, 10 n/s)", 13, 10, '$'
    menu_item2_message db "2. Output number (unsigned, 2  n/s)", 13, 10, '$'
    menu_item3_message db "3. Output number (signed,   16 n/s)", 13, 10, '$'
    input_menu_item_message db "Input menu number: ", '$'
dseg ends

sseg segment para stack 'STACK'
	db 512 dup(?)
sseg ends

cseg segment para public 'CODE'
    assume ds:dseg, ss:sseg

; dx - string offset
print_string proc near
    push ax
    mov ah, 09h
    int 21h
    pop ax
    ret
print_string endp

; ax - symbol
print_char proc near
    push dx
    mov dl, al
    mov ah, 2h
    int 21h
    pop dx
    ret
print_char endp

; al - number char
print_digit proc near
    add al, 30h
    call print_char
    ret
print_digit endp

print_newline proc near
    push ax
	mov al, 13
	call print_char
	mov al, 10
	call print_char
    pop ax
	ret
print_newline endp

input_jump_index proc near
    call input_char
    sub al, 30h
    mov bx, 2
    mul bx
    mov [jump_index], al
    ret
input_jump_index endp

; al - retval
input_char proc near
	mov ah, 01h
	int 21h
	ret
input_char endp

print_menu proc near
    lea dx, menu_message
    call print_string
    lea dx, menu_item0_message
    call print_string
    lea dx, menu_item1_message
    call print_string
    lea dx, menu_item2_message
    call print_string
    lea dx, menu_item3_message
    call print_string
    lea dx, input_menu_item_message
    call print_string
    ret
print_menu endp

exit proc near
    mov ax, 4c00h
    int 21h
exit endp

main:
    ; set data segment
    mov ax, dseg
    mov ds, ax

handle_menu:
    call print_menu
    call input_jump_index
    call print_newline

    xor bx, bx
    mov bl, [jump_index]
    mov bp, bx
    call [jump_table + bp]
    call print_newline
    jmp handle_menu

    call exit

cseg ends
end main
