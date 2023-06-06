#include <stdio.h>
#include <math.h>

#define PI_STR1 "3.14"
#define PI_STR2 "3.141596"

#define PI1 3.14
#define PI2 3.141596

float pi_float(void) {
    float result;
    asm volatile("fldpi\n"
                 "fstps %0\n" : "=m"(result));
    return result;
}

double pi_double(void) {
    double result;
    asm volatile("fldpi\n"
                 "fstpl %0\n" : "=m"(result));
    return result;
}

float sin_float(float pi) {
    float result;
    asm volatile("flds %1\n"
                 "fsin\n"
                 "fstps %0\n"
    : "=m"(result) : "m"(pi));
    return result;
}

double sin_double(double pi) {
    double result;
    asm volatile("fldl %1\n"
                 "fsin\n"
                 "fstpl %0\n"
    : "=m"(result) : "m"(pi));
    return result;
}

int main(void) {
    printf("library sinf(" PI_STR1 ") = %.10f\n", sinf(PI1));
    printf("library sin(" PI_STR1 ") = %.10f\n", sin(PI1));
    printf("library sinf(" PI_STR1 "/2) = %.10f\n", sinf(PI1 * 0.5));
    printf("library sin(" PI_STR1 "/2) = %.10f\n", sin(PI1 * 0.5));

    printf("library sinf(" PI_STR2 ") = %.10f\n", sinf(PI2));
    printf("library sin(" PI_STR2 ") = %.10f\n", sin(PI2));
    printf("library sinf(" PI_STR2 "/2) = %.10f\n", sinf(PI2 * 0.5));
    printf("library sin(" PI_STR2 "/2) = %.10f\n", sin(PI2 * 0.5));

    printf("custom sinf(" PI_STR1 ") = %.10f\n", sin_float(PI1));
    printf("custom sin(" PI_STR1 ") = %.10f\n", sin_double(PI1));
    printf("custom sinf(" PI_STR1 "/2) = %.10f\n", sin_float(PI1 * 0.5));
    printf("custom sin(" PI_STR1 "/2) = %.10f\n", sin_double(PI1 * 0.5));

    printf("custom sinf(" PI_STR2 ") = %.10f\n", sin_float(PI2));
    printf("custom sin(" PI_STR2 ") = %.10f\n", sin_double(PI2));
    printf("custom sinf(" PI_STR2 "/2) = %.10f\n", sin_float(PI2 * 0.5));
    printf("custom sin(" PI_STR2 "/2) = %.10f\n", sin_double(PI2 * 0.5));

    printf("libc sinf(coprocessor pi) = %.10f\n", sinf(pi_float()));
    printf("libc sin(coprocessor pi) = %.10f\n", sin(pi_double()));
    printf("libc sinf(coprocessor pi/2) = %.10f\n", sinf(pi_float() * 0.5));
    printf("libc sin(coprocessor pi/2) = %.10f\n", sin(pi_double() * 0.5));

    printf("my sinf(coprocessor pi) = %.10f\n", sin_float(pi_float()));
    printf("my sin(coprocessor pi) = %.10f\n", sin_double(pi_double()));
    printf("my sinf(coprocessor pi/2) = %.10f\n", sin_float(pi_float() * 0.5));
    printf("my sin(coprocessor pi/2) = %.10f\n", sin_double(pi_double() * 0.5));
}
