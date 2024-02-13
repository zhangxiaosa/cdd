#!/bin/bash

# 进入git仓库目录
repo="/data/m492zhan/review/icse24/artifact_evaluation/basex"
cd $repo

git reset --hard

# 初始化git bisect
git bisect start
git bisect bad 3c26407
git bisect good d1bb20b

# 定义bisect运行时的脚本
git bisect run /data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/bisect_script.sh

# 结束git bisect
git bisect reset

