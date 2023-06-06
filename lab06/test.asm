.model tiny

cseg segment
	assume cs:cseg, ds:cseg
    org 100h

main:
    jmp set_timer_handler

    prev_seconds db 0
    speed db 0fh
    prev_timer_handler dd 0

timer_interrupt:
    mov ah, 02h
    int 1ah

    cmp dh, prev_seconds
	je timer_interrupt_end
	mov prev_seconds, dh

    mov al, 0F3h
	out 60h, al
	mov al, speed
	out 60h, al

    dec speed
	test speed, 0fh
	jz reset
	jmp timer_interrupt_end

reset:
    mov speed, 0fh

timer_interrupt_end:
    call dword ptr prev_timer_handler

set_timer_handler:
    mov ax, 3508h
    int 21h

    mov word ptr prev_timer_handler, bx
	mov word ptr prev_timer_handler + 2, es

    mov ax, 2508h
	lea dx, timer_interrupt
    int 21h

    lea dx, set_timer_handler
	int 27h

cseg ends
end main
