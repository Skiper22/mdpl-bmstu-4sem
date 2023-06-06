.global my_strcpy

.text
my_strcpy:
	push ebp

	mov ebp, esp
	mov edx, [ebp + 16]
	mov esi, [ebp + 12]

	mov ecx, edx
	lea edi, copy_buffer
	
	rep movsb

	mov ecx, edx
	mov edi, [ebp + 8]
	lea esi, copy_buffer

	rep movsb

	pop ebp
	ret

.data
copy_buffer:
	.zero 256

