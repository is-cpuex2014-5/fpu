#vcd dumpfile fadd_sim.vcd
#vcd dumpvars -m fadd_sim -l 0
wave add -r /
wcfg save fadd_sim.wcfg
run all
#vcd dumpflush
exit
