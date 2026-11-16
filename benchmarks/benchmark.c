#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <assert.h>

static inline int8_t neuron_2in_relu(int8_t x0, int8_t x1, int8_t w0, int8_t w1, int8_t b) {
    int16_t p0 = (int16_t)x0 * (int16_t)w0;
    int16_t p1 = (int16_t)x1 * (int16_t)w1;
    int16_t z_sum = p0 + p1 + (int16_t)b;

    int16_t relu_out = (z_sum < 0) ? 0 : z_sum;
    int8_t sat_out = (relu_out > 127) ? 127 : (int8_t)relu_out;

    return sat_out;
}

int main(void) {
    const int8_t x0_arr[16] = { 3, -2,  5,  1, -4,  7,  0, -6,  2, 10, -1,  3,  6, -3,  5, -2};
    const int8_t x1_arr[16] = { 5,  4, -3,  2,  6, -1,  4,  3, -5, 10,  7, -4,  1,  5, -2,  3};
    const int8_t w0_arr[16] = { 4,  3, -2,  5,  1, -3,  2,  6, -4, 10,  2, -1,  4,  3, -5,  2};
    const int8_t w1_arr[16] = { 6, -1,  4,  3, -5,  2,  7, -4,  1, 10, -2,  3,  2, -4,  5,  1};
    const int8_t b_arr[16]  = {10,-15, 20, -5, 12,-25,  0,  8,-12, 50,-30,  5, 18, -8, 22,-14};

    assert(neuron_2in_relu(3, 5, 4, 6, 10) == 52);
    assert(neuron_2in_relu(3, 5, 4, 6, -60) == 0);
    assert(neuron_2in_relu(10, 10, 10, 10, 50) == 127);

    const int ITERATIONS = 10000000;
    struct timespec start, end;
    volatile int8_t acc = 0;

    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < ITERATIONS; i++) {
        int idx = i & 0x0F;
        acc ^= neuron_2in_relu(x0_arr[idx], x1_arr[idx], w0_arr[idx], w1_arr[idx], b_arr[idx]);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    double total_ns = (double)(end.tv_sec - start.tv_sec) * 1e9 + (double)(end.tv_nsec - start.tv_nsec);
    double avg_ns = total_ns / ITERATIONS;

    printf("C (gcc -O2):\n");
    printf("  Iterations: %d\n", ITERATIONS);
    printf("  Latency:    %.2f ns/inf\n", avg_ns);
    printf("  Throughput: %.1f M inf/sec\n", 1000.0 / avg_ns);

    return 0;
}
