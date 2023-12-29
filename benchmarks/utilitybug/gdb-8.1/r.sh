#! /bin/bash

BIN_PATH="/home/coq/cdd/benchmarks/utilitybug/gdb-8.1/src/build/bin/gdb"

TIMEOUT=30

timeout -s 9 $TIMEOUT $BIN_PATH < input > out.txt 2>&1
ret=$?
if [ $ret != 139 ]; then
	exit 1
fi

exit 0
