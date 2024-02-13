#!/bin/bash

# 定义case folder路径，这个路径应该作为脚本的第一个参数传入
CASE_FOLDER=$1

# 进入git仓库目录
repo="/data/m492zhan/review/icse24/artifact_evaluation/basex"
cd ${repo}
# 编译项目
rm ${repo}/basex-core/target/*
mvn package -Dmaven.test.skip

# 复制jar文件
cp ${repo}/basex-core/target/basex-*-SNAPSHOT.jar ${repo}/basex-core/target/basex.jar

git reset --hard

# 进入case folder执行r.sh
cd /data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xml2
./r.sh

# 根据r.sh的返回值决定当前commit是good还是bad
if [ $? -eq 0 ]; then
    exit 0
else
    exit 1
fi
