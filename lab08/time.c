#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

void compare_float(size_t count) {
    volatile float x = rand();
    volatile float y = rand();
    volatile float result;

    clock_t start = clock();
    for (size_t i = 0; i < count; i++)
        result = x + y;

    printf("\nsum: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);

    start = clock();
    for (size_t i = 0; i < count; i++)
        result = x * y;

    printf("mul: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);
}

void compare_double(size_t count) {
    volatile double x = rand();
    volatile double y = rand();
    volatile double result;

    clock_t start = clock();
    for (size_t i = 0; i < count; i++)
        result = x + y;

    printf("\nsum: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);

    start = clock();
    for (size_t i = 0; i < count; i++)
        result = x * y;

    printf("mul: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);
}

void compare_float_asm(size_t count) {
    volatile float x = rand();
    volatile float y = rand();
    volatile float result = x + y;

    clock_t start = clock();
    for (size_t i = 0; i < count; i++)
            asm volatile("flds %1\n"
                         "flds %2\n"
                         "faddp\n"
                         "fstps %0\n"
            : "=m"(result)
            : "m" (x), "m"(y));

    printf("\nsum: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);

    start = clock();
    for (size_t i = 0; i < count; i++)
            asm volatile("flds %1\n"
                         "flds %2\n"
                         "fmulp\n"
                         "fstps %0\n"
            : "=m"(result)
            : "m" (x), "m"(y));

    printf("mul: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);
}

void compare_double_asm(size_t count) {
    volatile double x = rand();
    volatile double y = rand();
    volatile double result = x + y;

    clock_t start = clock();
    for (size_t i = 0; i < count; ++i)
            asm volatile("fldl %1\n"
                         "fldl %2\n"
                         "faddp\n"
                         "fstpl %0\n"
            : "=m"(result) : "m" (x), "m"(y));

    printf("\nsum: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);

    start = clock();
    for (size_t i = 0; i < count; ++i)
            asm volatile("fldl %1\n"
                         "fldl %2\n"
                         "fmulp\n"
                         "fstpl %0\n"
            : "=m"(result) : "m" (x), "m"(y));

    printf("mul: %lu us\n", ((unsigned long)(clock() - start) * 1000000) / CLOCKS_PER_SEC);
}

int main(int argc, char **argv) {
    size_t count = 1e7;
    if (argc == 2 && strcmp(argv[1], "asm") == 0) {
        printf("compare float asm: ");
        compare_float_asm(count);
        printf("compare double asm: ");
        compare_double_asm(count);
    } else {
        printf("compare float: ");
        compare_float(count);
        printf("compare double: ");
        compare_double(count);
    }
}
