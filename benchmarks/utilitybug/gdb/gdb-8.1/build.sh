#! /bin/bash
mkdir -p build/bin/
if [ ! -f Makefile ]; then
    ./configure --prefix=/home/coq/cdd/benchmarks/utilitybug/gdb-8.1
fi
make -j8
cp ./gdb/gdb ./build/bin/
