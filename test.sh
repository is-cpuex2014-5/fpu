#!/bin/bash

tests=fmul_sim

for a in $tests; do
    if ./$a; then
	echo "test of "$a" passed";
    else
	echo "test of "$a" NOT passed!!";
	exit 1;
    fi    
done

