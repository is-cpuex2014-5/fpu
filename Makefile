GHDL = ghdl
GHDLFLAGS = --ieee=synopsys -fexplicit
OBJS = fmul_stage1.o fmul_stage2.o fmul_stage3.o fmul.o fmul_sim.o fadd_stage1.o fadd_stage2.o fadd_stage3.o fadd.o fadd_sim.o right_shift.o ZLC.o fsub.o fsub_sim.o fsub_stage1.o fmul_tb.o fmul_tb_sim.o fadd_tb.o fadd_tb_sim.o fsub_tb.o fsub_tb_sim.o floor.o floor_sim.o floor_tb.o floor_tb_sim.o ZLC_31.o i2f.o i2f_sim.o i2f_tb.o i2f_tb_sim.o finv.o finv_sim.o finv_tb.o finv_tb_sim.o
TESTBENCH = fmul_sim fadd_sim fsub_sim fmul_tb_sim fadd_tb_sim fsub_tb_sim floor_sim floor_tb_sim  i2f_sim i2f_tb_sim finv_sim finv_tb_sim

all: $(TESTBENCH)

fadd_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fmul_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fsub_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

floor_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

i2f_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

finv_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fmul_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fadd_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fsub_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

floor_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

i2f_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

finv_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

test:$(TESTBENCH)
	./test.sh

clean:
	rm -f $(OBJS) $(TESTBENCH)
