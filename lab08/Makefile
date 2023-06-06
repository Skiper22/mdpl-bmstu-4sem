CC = gcc
AS := as
	
clean:
	rm *.exe *.o time sse pi

run: 
	@gcc -O0 -m80387 -mfpmath=387 time.c -o time
	@gcc -O0 sse.c -mno-sse -o sse
	@gcc -O0 -m80387 -mfpmath=387 pi.c -lm -o pi
	@./sse
	@echo
	@./time
	@echo
	@./time asm
	@echo
	@./pi

.PHONY: clean

.DEFAULT_GOAL := run

