#!/bin/bash
# deletes the temp directory
function cleanup {
  echo "Deleting $1"
  rm -rf $1
}

function clean_unfinished(){
  cleanup $log_path
  cleanup $work_path
}

function handle_interrupt(){
  echo "Interrupt received. Cleaning up and exiting."
  clean_unfinished
  exit 1
}

trap handle_interrupt INT

root=$(pwd)
benchmark_path=${root}/benchmarks/compilerbug
args=$1

# output folder
out_folder_name=$(date +"%Y%m%d%H%M%S")
out_path="${root}/results/${out_folder_name}"
echo "out_path is ${out_path}"
if [ ! -d "$out_path" ]; then
    mkdir -p $out_path
fi

# check the git version
echo "Checking the current git version."
version="Current git version: $(git rev-parse --short HEAD)."
if [ $? -eq 0 ]; then
  echo "${version}"
else
  echo "No git version available."
fi

# save the version and args
config_path=${out_path}/config.txt
echo "${version}" > ${config_path}
echo -e "\n" >> ${config_path}
echo -e "$0 ${args}" >> ${config_path}

log_path="init"
data_path="init"

# all cases
 for target in 'clang-22382' 'clang-22704' 'clang-23309' 'clang-23353' 'clang-25900' 'clang-26760' 'clang-27137' 'clang-27747' 'clang-31259' 'gcc-59903' 'gcc-60116' 'gcc-61383' 'gcc-61917' 'gcc-64990' 'gcc-65383' 'gcc-66186' 'gcc-66375' 'gcc-70127' 'gcc-70586' 'gcc-71626';
do

    # init log and data path
    log_path=${out_path}/log_${target}.txt
    data_path=${out_path}/result_${target}

    if [ -d ${log_path} ] || [ -f ${data_path} ]; then
	    echo "already done ${target}"
      continue
    fi	    
    echo "running $target"

    # create tmp folder
    work_path=`mktemp -d -p ${out_path}`
    echo "created tmp folder ${work_path} for ${target}"
    cp ${benchmark_path}/$target/r.sh $work_path
    cp ${benchmark_path}/$target/small.c $work_path/small.c
    cp ${benchmark_path}/C.g4 $work_path
    cd $work_path

    # record picireny version and run the benchmark
    picireny --version > ${log_path}
    picireny -i small.c --test r.sh --grammar C.g4 --start compilationUnit --disable-cleanup --cache none --sys-recursion-limit 10000000 $1 >> ${log_path} 2>&1
    # save result, cleanup
    mv small.c.* ${data_path}
    cd ${root}
    cleanup ${work_path}
done
