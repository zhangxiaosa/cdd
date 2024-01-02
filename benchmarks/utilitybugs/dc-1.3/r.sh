#! /bin/bash
UTILITY="dc"
VERSION="1.3"
BIN_PATH="/home/coq/cdd/benchmarks/utilitybug/${UTILITY}-${VERSION}/src/build/bin/${UTILITY}"

TIMEOUT=30

timeout -s 9 $TIMEOUT $BIN_PATH < input > out.txt 2>&1
ret=$?
if [ $ret != 139 ]; then
	exit 1
fi

exit 0
