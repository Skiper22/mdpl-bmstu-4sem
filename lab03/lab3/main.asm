; из двух модулей. Точку входа разместить в первом, затем передать
; управление с помощью дальнего перехода во второй, где ввести
; строчную букву латинского алфавита, вернуть управление в первый
; и вывести заглавный аналог этой буквы

PUBLIC C1
PUBLIC return
EXTRN input_char: far

SSTK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
SSTK ENDS

SD1 SEGMENT PARA PUBLIC 'DATA'
	C1 db '$'
SD1 ENDS

SC1 SEGMENT PARA PUBLIC 'CODE'
	assume CS:SC1, DS:SD1
main:
	call input_char
return:
    sub [C1], 32

	mov ah, 2
    mov dl, C1
    int 21h

    mov ax, 4c00h
    int 21h
SC1 ENDS
END main
