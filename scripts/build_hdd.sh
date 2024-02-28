#! /bin/bash
root=$(pwd)
cd ${root}
git_version=$(git rev-parse --short HEAD)

# install picire
cd ${root}/src/picire-21.8
version=$(cat picire-21.8/picire/VERSION)
full_version="picire-${version}+${git_version}"
pip install .
if pip list | grep -q "$full_version"; then
    echo "$full_version is already installed. Skipping installation."
else
    echo "$full_version is not installed. Installing..."
    pip install .
fi

# install picireny
cd ${root}/src/picireny-21.8
version=$(cat picireny-21.8/picireny/VERSION)
full_version="picireny-${version}+${git_version}"
pip install .
if pip list | grep -q "$full_version"; then
    echo "$full_version is already installed. Skipping installation."
else
    echo "$full_version is not installed. Installing..."
    pip install .
fi

cd ${root}