#! /bin/bash
root=$(pwd)
pushd ${root}/benchmarks/utilitybugs > /dev/null

for folder in */
do
    pushd "${folder}/src" > /dev/null  
    
    if [[ -f "build.sh" ]]
    then
        echo "Running build.sh in ${folder}"
        ./build.sh  
    else
        echo "build.sh not found in ${folder}"
    fi

    popd > /dev/null  
done

popd > /dev/null  
