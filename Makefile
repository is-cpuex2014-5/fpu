TESTBENCH = fmul_sim fadd_sim fsub_sim fmul_tb_sim fadd_tb_sim fsub_tb_sim floor_sim floor_tb_sim  i2f_sim i2f_tb_sim finv_sim finv_tb_sim feq_sim feq_tb_sim flt_sim flt_tb_sim fsqrt_sim fsqrt_tb_sim

all: $(TESTBENCH)

fadd_sim: fadd_sim.prj fadd.vhd fadd_sim.vhd fadd_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd
	fuse -incremental -prj $< -o $@ fadd_sim

fsub_sim: fsub_sim.prj fsub.vhd fsub_sim.vhd fsub_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd
	fuse -incremental -prj $< -o $@ fsub_sim

fmul_sim: fmul_sim.prj fmul.vhd fmul_sim.vhd fmul_stage1.vhd fmul_stage2.vhd fmul_stage3.vhd
	fuse -incremental -prj $< -o $@ fmul_sim

floor_sim: floor_sim.prj floor_sim.vhd floor.vhd
	fuse -incremental -prj $< -o $@ floor_sim

i2f_sim: i2f_sim.prj i2f.vhd i2f_sim.vhd ZLC_31.vhd
	fuse -incremental -prj $< -o $@ i2f_sim

finv_sim: finv_sim.prj finv.vhd finv_sim.vhd
	fuse -incremental -prj $< -o $@ $@

fadd_tb_sim: fadd_tb_sim.prj fadd.vhd fadd_tb_sim.vhd fadd_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd fadd_tb.vhd
	fuse -incremental -prj $< -o $@ fadd_sim

fsub_tb_sim: fsub_tb_sim.prj fsub.vhd fsub_tb_sim.vhd fsub_stage1.vhd fadd_stage2.vhd fadd_stage3.vhd right_shift.vhd ZLC.vhd fsub_tb.vhd
	fuse -incremental -prj $< -o $@ fsub_sim

fmul_tb_sim: fmul_tb_sim.prj fmul.vhd fmul_sim.vhd fmul_stage1.vhd fmul_stage2.vhd fmul_stage3.vhd fmul_tb.vhd
	fuse -incremental -prj $< -o $@ fmul_tb_sim

finv_tb_sim: finv_tb_sim.prj finv.vhd finv_tb.vhd finv_tb_sim.vhd
	fuse -incremental -prj $< -o $@ $@

floor_tb_sim: floor_tb_sim.prj floor_tb_sim.vhd floor.vhd floor_tb.vhd
	fuse -incremental -prj $< -o $@ $@

i2f_tb_sim: i2f_tb_sim.prj i2f.vhd i2f_tb_sim.vhd i2f_tb.vhd ZLC_31.vhd
	fuse -incremental -prj $< -o $@ $@

feq_sim: feq_sim.prj feq.vhd feq_sim.vhd
	fuse -incremental -prj $< -o $@ $@

feq_tb_sim: feq_tb_sim.prj feq.vhd feq_sim.vhd feq_tb_sim.vhd
	fuse -incremental -prj $< -o $@ $@

flt_sim: flt_sim.prj flt.vhd flt_sim.vhd
	fuse -incremental -prj $< -o $@ $@

fsqrt_sim: fsqrt_sim.prj fsqrt.vhd fsqrt_sim.vhd
	fuse -incremental -prj $< -o $@ $@

flt_tb_sim: flt_tb_sim.prj flt.vhd flt_sim.vhd flt_tb_sim.vhd
	fuse -incremental -prj $< -o $@ $@

fsqrt_tb_sim: fsqrt_tb_sim.prj fsqrt.vhd fsqrt_sim.vhd fsqrt_tb_sim.vhd
	fuse -incremental -prj $< -o $@ $@

test:$(TESTBENCH)
	./test.sh

clean:
	rm -f *.o $(TESTBENCH) *.vcd
