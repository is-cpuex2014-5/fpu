#!/bin/sh

# please change this variable when test target is changed
tests="fadd_sim fsub_sim fmul_sim finv_sim floor_sim i2f_sim floor_sim fsqrt_sim feq_sim flt_sim fabs_sim fneg_sim f2i_sim"
ERROR_MES="User(VHDL) Code Called Simulation Stop"


NUM=$(echo $tests | wc -w)
PASSED="0"
FAILED="0"

if [ $NUM -eq 1 ]; then
    echo -e "\e[32m[==========]\e[0m Running 1 test";  
else
    echo -e "\e[32m[==========]\e[0m Running $NUM tests";  
fi

for a in $tests; do
    echo -e "\e[32m[ RUN      ]\e[0m $a";
    if echo "run all" | ./$a | grep "$ERROR_MES" > /dev/null; then
	echo -e "\e[31m[  FAILED  ]\e[0m $a";
	FAILED=$(( $FAILED + 1));
    else
	echo -e "\e[32m[  PASSED  ]\e[0m $a";
	PASSED=$(( $PASSED + 1));
    fi;
done
echo -e "\e[32m[==========]\e[0m";  
if [ $PASSED -eq 1 ]; then
    echo -e "\e[32m[  PASSED  ]\e[0m $PASSED test.";
elif [ $PASSED -gt 1 ]; then
    echo -e "\e[32m[  PASSED  ]\e[0m $PASSED tests.";
fi;

if [ $FAILED -eq 1 ]; then
    echo -e "\e[31m[  FAILED  ]\e[0m $FAILED test.";
elif [ $FAILED -gt 1 ]; then
    echo -e "\e[31m[  FAILED  ]\e[0m $FAILED tests.";
else
    exit 0;
fi;
exit 1;
