#! /bin/bash
root=$(pwd)
cd ${root}/src/chisel
cmake -S . -B ${root}/build
cd ${root}/build
make
cd ${root}
