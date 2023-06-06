#include <stdio.h>
#include <string.h>

int main(void) {
	char str[128] = "Hello world\n";
	size_t len = strlen(str);
	strncpy(str + 3, str, len);
	printf("%s\n", str);
}
