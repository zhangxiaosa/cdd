#!/bin/bash

# 进入git仓库目录
repo="/data/m492zhan/review/icse24/artifact_evaluation/basex-bisect"
cd $repo
latest_version="3c26407"
oldest_version="8ede04"
git reset --hard

git checkout $latest_version
/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/bisect_script.sh
if [ $? -eq 0 ]; then
    echo "bad init commit not bad"
    exit 1
fi
git checkout $oldest_version
/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/bisect_script.sh
if [ $? -eq 1 ]; then
    echo "good init commit not good"
    exit 1
fi


# 初始化git bisect
git bisect start
git bisect bad $latest_version
git bisect good $oldest_version

# 定义bisect运行时的脚本
git bisect run /data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/bisect_script.sh

# 结束git bisect
git bisect reset

