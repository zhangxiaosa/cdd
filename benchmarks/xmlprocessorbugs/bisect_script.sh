#!/bin/bash

# 定义case folder路径，这个路径应该作为脚本的第一个参数传入
CASE_FOLDER="/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xml28"

# 进入git仓库目录
repo="/data/m492zhan/review/icse24/artifact_evaluation/basex-bisect"
cd ${repo}
# 编译项目
sed -i 's|http://repo2.maven.org/maven2/|https://repo.maven.apache.org/maven2/|g' pom.xml
mvn clean > /dev/null
mvn package -Dmaven.test.skip > /dev/null

# 复制jar文件
rm ${repo}/basex-core/target/*-sources.jar
cp ${repo}/basex-core/target/basex-*.jar ${repo}/basex-core/target/basex.jar
git reset --hard

# 进入case folder执行r.sh
cd $CASE_FOLDER
echo "case folder is" $CASE_FOLDER
./r.sh
ret=$?
cd ${repo}
# 根据r.sh的返回值决定当前commit是good还是bad
if [ $ret -eq 0 ]; then
    echo "returns 0"
    exit 0
else
    echo "returns 1"
    exit 1
fi
