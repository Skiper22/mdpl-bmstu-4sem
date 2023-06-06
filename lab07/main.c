#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STR_MAX_SIZE 256

extern void my_strcpy(char *dst, char *src, size_t len);

int main(void) {
    char string[STR_MAX_SIZE] = "Hello world\n";
    size_t len = 0;

	asm (
        "lea edi, [%1] \n\t"
		"xor ecx, ecx \n\t"
		"loop1: \n\t"
		"xor eax, eax \n\t"
		"mov eax, [edi] \n\t"
		"inc ecx \n\t"
		"inc edi \n\t"
		"cmp al, 0 \n\t"
		"jne loop1 \n\t"
		"dec ecx \n\t"
		"mov %0, ecx \n\t"
        : "=r" (len)
        : "r" (string)
    );
	
	printf("string len = %zu, real len = %zu\n\n", len, strlen(string));

	char buffer[STR_MAX_SIZE] = {0};
	my_strcpy(buffer, string, len);
	printf("copy to buffer: %s\n", buffer);	

	char string2[STR_MAX_SIZE] = "Hello world\n";
	my_strcpy(string2 + 3, string2, len);
	printf("overlap right: %s\n", string2);

	char string3[STR_MAX_SIZE] = "Hello world\n";
	my_strcpy(string3, string3 + 3, len);
	printf("overlap left: %s\n", string3);

    return 0;
}
