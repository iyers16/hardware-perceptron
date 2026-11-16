GHDL    ?= ghdl
YOSYS   ?= yosys
GTKWAVE ?= gtkwave
CC      ?= gcc
CFLAGS  ?= -O2 -Wall
PYTHON  ?= python3

SRC     = hdl/neuron_2in_relu.vhd
TB      = sim/tb_neuron.vhd
VCD     = sim/waveform.vcd

.PHONY: all sim wave synth bench bench-c bench-py clean

all: sim bench

sim:
	$(GHDL) -a --std=08 $(SRC) $(TB)
	$(GHDL) -e --std=08 tb_neuron
	$(GHDL) -r --std=08 tb_neuron --vcd=$(VCD)

wave: sim
	$(GTKWAVE) $(VCD) &

synth:
	$(YOSYS) -m ghdl -p "ghdl --std=08 $(SRC) -e neuron_2in_relu; synth; stat"

bench: bench-c bench-py

bench-c:
	$(CC) $(CFLAGS) benchmarks/benchmark.c -o benchmarks/bench_c
	./benchmarks/bench_c

bench-py:
	$(PYTHON) benchmarks/benchmark.py

clean:
	rm -f *.o e~*.o e~* work-obj*.cf tb_neuron benchmarks/bench_c $(VCD)
	$(GHDL) --clean 2>/dev/null || true
