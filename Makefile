GHDL = ghdl
GHDLFLAGS = --ieee=synopsys -fexplicit
OBJS = fmul_stage1.o fmul_stage2.o fmul_stage3.o fmul.o fmul_sim.o fadd_stage1.o fadd_stage2.o fadd_stage3.o fadd.o fadd_sim.o right_shift.o ZLC.o fsub.o fsub_sim.o fsub_stage1.o fmul_tb.o fmul_tb_sim.o fadd_tb.o fadd_tb_sim.o fsub_tb.o fsub_tb_sim.o floor.o floor_sim.o floor_tb.o floor_tb_sim.o ZLC_31.o i2f.o i2f_sim.o i2f_tb.o i2f_tb_sim.o finv.o finv_sim.o finv_tb.o finv_tb_sim.o feq.o feq_sim.o feq_tb.o feq_tb_sim.o flt.o flt_sim.o flt_tb.o flt_tb_sim.o fsqrt.o fsqrt_sim.o fsqrt_tb.o fsqrt_tb_sim.o i2f_sim_pipe.o
TESTBENCH = fmul_sim fadd_sim fsub_sim fmul_tb_sim fadd_tb_sim fsub_tb_sim floor_sim floor_tb_sim  i2f_sim i2f_tb_sim finv_sim finv_tb_sim feq_sim feq_tb_sim flt_sim flt_tb_sim fsqrt_sim fsqrt_tb_sim i2f_sim_pipe fadd_isim i2f_isim

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

feq_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

flt_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fsqrt_sim:$(OBJS)
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

feq_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

flt_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

fsqrt_tb_sim: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

i2f_sim_pipe: $(OBJS)
	$(GHDL) -e $(GHDLFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

fadd_isim: fadd_sim.prj fadd.vhd fadd_sim.vhd fadd_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd
	fuse -incremental -prj $< -o $@ fadd_sim

i2f_isim: i2f_sim.prj i2f.vhd i2f_sim.vhd ZLC_31.vhd
	fuse -incremental -prj $< -o $@ i2f_sim

test:$(TESTBENCH)
	./test.sh

clean:
	rm -f *.o $(TESTBENCH) *.vcd
