CC = gcc
AS := as

build:
	$(AS) --32 -g -msyntax=intel -mnaked-reg -o strcpy.o strcpy.s
	$(CC) -c -g -m32 -masm=intel -o main.o main.c
	$(CC) -m32 -o main main.o strcpy.o

clean:
	rm *.exe *.o main

run: build
	./main

.PHONY: build clean

.DEFAULT_GOAL := run

