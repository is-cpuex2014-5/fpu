#!/bin/bash

tests="fmul_sim fadd_sim fsub_sim finv_sim floor_sim i2f_sim"

for a in $tests; do
    if ./$a; then
	echo "test of "$a" passed";
    else
	echo "test of "$a" NOT passed!!";
	exit 1;
    fi    
done

