#! /bin/bash
UTILITY="as"
VERSION="2.30"
BIN_PATH="/home/coq/cdd/benchmarks/utilitybug/${UTILITY}-${VERSION}/src/build/bin/${UTILITY}"

TIMEOUT=30

timeout -s 9 $TIMEOUT $BIN_PATH -a input > out.txt 2>&1
ret=$?
if [ $ret != 137 ]; then
	exit 1
fi

exit 0
