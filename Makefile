GHDL = ghdl
GHDLFLAGS = --ieee=synopsys -fexplicit
OBJS = fmul_stage1.o fmul_stage2.o fmul_stage3.o fmul.o fmul_sim.o
TESTBENCH = fmul_sim

all: $(TESTBENCH)

$(TESTBENCH): $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

clean:
	rm -f $(OBJS) $(TESTBENCH)
