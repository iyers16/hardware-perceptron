#!/usr/bin/env python3
import time

def neuron_2in_relu(x0: int, x1: int, w0: int, w1: int, b: int) -> int:
    z_sum = (x0 * w0) + (x1 * w1) + b
    relu_out = 0 if z_sum < 0 else z_sum
    return 127 if relu_out > 127 else relu_out

def main():
    x0_arr = [ 3, -2,  5,  1, -4,  7,  0, -6,  2, 10, -1,  3,  6, -3,  5, -2]
    x1_arr = [ 5,  4, -3,  2,  6, -1,  4,  3, -5, 10,  7, -4,  1,  5, -2,  3]
    w0_arr = [ 4,  3, -2,  5,  1, -3,  2,  6, -4, 10,  2, -1,  4,  3, -5,  2]
    w1_arr = [ 6, -1,  4,  3, -5,  2,  7, -4,  1, 10, -2,  3,  2, -4,  5,  1]
    b_arr  = [10,-15, 20, -5, 12,-25,  0,  8,-12, 50,-30,  5, 18, -8, 22,-14]

    assert neuron_2in_relu(3, 5, 4, 6, 10) == 52
    assert neuron_2in_relu(3, 5, 4, 6, -60) == 0
    assert neuron_2in_relu(10, 10, 10, 10, 50) == 127

    iterations = 5_000_000
    t0 = time.perf_counter_ns()
    acc = 0
    for i in range(iterations):
        idx = i & 0x0F
        acc ^= neuron_2in_relu(x0_arr[idx], x1_arr[idx], w0_arr[idx], w1_arr[idx], b_arr[idx])
    t1 = time.perf_counter_ns()

    avg_ns = (t1 - t0) / iterations
    print(f"Python 3:")
    print(f"  Iterations: {iterations:,}")
    print(f"  Latency:    {avg_ns:.2f} ns/inf")
    print(f"  Throughput: {1000.0 / avg_ns:.1f} M inf/sec")

if __name__ == "__main__":
    main()
