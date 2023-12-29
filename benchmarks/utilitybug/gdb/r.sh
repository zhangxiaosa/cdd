#! /bin/bash

BIN_PATH="/home/coq/cdd/benchmarks/utilitybug/gdb/gdb-8.1/build/bin/gdb"

TIMEOUT=20

timeout -s 9 $TIMEOUT $BIN_PATH < input > out.txt 2>&1
ret=$?
if [ $ret != 139 ]; then
	exit 1
fi

exit 0
