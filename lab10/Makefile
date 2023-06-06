.PHONY: clean

build:
	nasm -felf64 -g -o main.o main.s
	gcc -no-pie `pkg-config --cflags gtk+-3.0` -o main main.o `pkg-config --libs gtk+-3.0`

clean:
	rm main.o main
