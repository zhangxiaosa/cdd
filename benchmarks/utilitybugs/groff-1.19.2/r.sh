#! /bin/bash
UTILITY="groff"
VERSION="1.19.2"
BIN_PATH="/home/coq/cdd/benchmarks/utilitybugs/${UTILITY}-${VERSION}/bin/${UTILITY}"

TIMEOUT=30

timeout -s 9 $TIMEOUT $BIN_PATH -mtty-char -Tascii < input > out.txt 2>&1
ret=$?
if [ $ret != 137 ]; then
	exit 1
fi
rm out.txt
exit 0
