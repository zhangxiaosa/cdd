#! /bin/bash
$(dirname $0)/sut-json-load.py $1 2>&1 | grep -q "Error: Expecting property name enclosed in double quotes:"
