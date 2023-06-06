CC = gcc
AS := as
	
clean:
	rm *.exe *.o time sse pi

run: 
	gcc -O0 main.c -masm=intel -o main

.PHONY: clean

.DEFAULT_GOAL := run

