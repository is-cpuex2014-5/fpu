GHDL = ghdl
GHDLFLAGS = --ieee=synopsys -fexplicit
OBJS = fmul_stage1.o fmul_stage2.o fmul_stage3.o fmul.o fmul_sim.o fadd_stage1.o fadd_stage2.o fadd_stage3.o fadd.o fadd_sim.o right_shift.o ZLC.o fsub.o fsub_sim.o fsub_stage1.o
TESTBENCH = fmul_sim fadd_sim fsub_sim

all: $(TESTBENCH)

fadd_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fmul_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fsub_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@


%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

test:$(TESTBENCH)
	./test.sh

clean:
	rm -f $(OBJS) $(TESTBENCH)
