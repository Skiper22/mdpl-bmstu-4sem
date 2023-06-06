EXTRN C1: byte
EXTRN return: far
PUBLIC input_char

SC2 SEGMENT PARA PUBLIC 'CODE'
input_char proc far
	mov ah, 8
	int 21h

	mov C1, al
	ret
input_char endp
SC2 ENDS
END