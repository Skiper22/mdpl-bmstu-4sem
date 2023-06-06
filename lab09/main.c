#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <xmmintrin.h>

#define VECTOR_SIZE 32
#define COMPARE_COUNT 100000

struct vector {
    volatile float *data;
    size_t size;
};

static struct vector *create_random_vector(size_t size) {
    struct vector *vec = malloc(sizeof(struct vector) + size * sizeof(float));
    if (vec == NULL)
        return NULL;

    vec->size = size;
    vec->data = (float *)(vec + 1);

    for (size_t i = 0; i < size; i++)
        vec->data[i] = (float)rand() / (float)RAND_MAX;

    return vec;
}

static void compare_vector_dot_asm(struct vector *vec1, struct vector *vec2) {
    if (vec1->size != vec2->size) {
        printf("different vector sizes\n");
        return;
    }

    float dot = 0;
    clock_t start, total = 0;
    for (size_t i = 0; i < COMPARE_COUNT; i++) {
        dot = 0;
        __m128 *vec_data1 = (__m128 *)vec1->data;
        __m128 *vec_data2 = (__m128 *)vec2->data;
        float temp = 0;
        start = clock();
        for (size_t j = 0; j < vec1->size; j += 4, vec_data1++, vec_data2++) {
            asm volatile("movups xmm0, %1\n\t"
                         "movups xmm1, %2\n\t"
                         "mulps xmm0, xmm1\n\t"
                         "movhlps xmm1, xmm0\n\t"
                         "addps xmm0, xmm1\n\t"
                         "movups xmm1, xmm0\n\t"
                         "shufps xmm0, xmm0, 1\n\t"
                         "addps xmm0, xmm1\n\t"
                         "movss %0, xmm0\n\t"
            : "=m"(temp)
            : "m" (*vec_data1),
            "m"(*vec_data2));
            dot += temp;
        }
        total += clock() - start;
    }

    printf("compare vector dot = %f asm: %lu us\n", dot,
           ((unsigned long)(total * 1000000) / CLOCKS_PER_SEC));
}

static void compare_vector_dot(struct vector *vec1, struct vector *vec2) {
    if (vec1->size != vec2->size) {
        printf("different vector sizes\n");
        return;
    }

    float dot = 0;
    clock_t start, total = 0;
    for (size_t i = 0; i < COMPARE_COUNT; i++) {
        dot = 0;
        start = clock();
        for (size_t j = 0; j < vec1->size; j++)
            dot += vec1->data[j] * vec2->data[j];
        total += clock() - start;
    }

    printf("compare vector dot = %f c/c++: %lu us\n", dot,
           ((unsigned long)(total * 1000000) / CLOCKS_PER_SEC));
}

int main(void) {
    struct vector *vec1 = create_random_vector(VECTOR_SIZE);
    struct vector *vec2 = create_random_vector(VECTOR_SIZE);
    compare_vector_dot(vec1, vec2);
    compare_vector_dot_asm(vec1, vec2);
}
