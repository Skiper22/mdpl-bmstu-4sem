#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

void compare_float(size_t count) {
    volatile float x = rand();
    volatile float y = rand();
    volatile float result = x + y;

    clock_t start = clock();
    for (size_t i = 0; i < count; i++)
        result = x + y;

    clock_t compare_time = clock() - start;

    start = clock();
    for (size_t i = 0; i < count; i++)
        result = x * y;

    compare_time += clock() - start;

    printf("%lu us\n", ((unsigned long)compare_time * 1000000) / CLOCKS_PER_SEC);
}

void compare_double(size_t count) {
    volatile double x = rand();
    volatile double y = rand();
    volatile double result = x + y;

    clock_t start = clock();
    for (size_t i = 0; i < count; i++)
        result = x + y;

    clock_t compare_time = clock() - start;

    start = clock();
    for (size_t i = 0; i < count; i++)
        result = x * y;

    compare_time += clock() - start;

    printf("%lu us\n", ((unsigned long)compare_time * 1000000) / CLOCKS_PER_SEC);
}

int main(int argc, char **argv) {
    size_t count = 1e7;
	printf("sse disabled, coprocessor disabled\n");
    printf("compare float: ");
    compare_float(count);
    printf("compare double: ");
	compare_double(count);
}

