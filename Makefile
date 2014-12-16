UNITS = fadd fsub fmul finv fsqrt floor i2f feq flt fabs fneg
SIMS = $(UNITS:%=%_sim)
TB_SIMS = $(UNITS:%=%_tb_sim)
TESTBENCH = $(SIMS) $(TB_SIMS)
vpath %.vhd src 
vpath %.prj testbench
vpath %_sim.vhd testbench
vpath %_tb.vhd testbench

all: $(TESTBENCH)

fadd_deps := fadd_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd

fadd_sim: $(fadd_deps)
fadd_tb_sim: $(fadd_deps)

fsub_deps := fsub_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd

fsub_sim: $(fsub_deps)
fsub_tb_sim: $(fsub_deps)

fmul_deps := fmul_stage1.vhd fmul_stage2.vhd fmul_stage3.vhd

fmul_sim: $(fmul_deps)
fmul_tb_sim: $(fmul_deps)

i2f_deps := ZLC_31.vhd

i2f_sim: $(i2f_deps)
i2f_tb_sim: $(i2f_deps)

%_sim: %_sim.prj %.vhd %_sim.vhd
	fuse -incremental -prj $< -o $@ $@

%_tb_sim: %_tb_sim.prj %_tb.vhd %_tb_sim.vhd %.vhd
	fuse -incremental -prj $< -o $@ $@

test:$(TESTBENCH)
	@./test.sh

clean:
	rm -f $(TESTBENCH) *.wdb

.PHONY: all clean test
