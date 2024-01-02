#! /bin/bash
root=$(pwd)
pushd ${root}/benchmarks/utilitybugs > /dev/null

for folder in */
do
    pushd "${folder}/src" > /dev/null
    echo "Processing folder ${folder}"
    
    if [[ -f "build.sh" ]]
    then
        echo "Running build.sh in ${folder}/src"
        ./build.sh > /dev/null
       	echo "Finished build.sh in ${folder}/src"
    else
        echo "build.sh not found in ${folder}/src"
    fi

    popd > /dev/null  
done

popd > /dev/null  
