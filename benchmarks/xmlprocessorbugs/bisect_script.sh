#!/bin/bash

# 定义case folder路径，这个路径应该作为脚本的第一个参数传入
CASE_FOLDER="/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xml64"

# 进入git仓库目录
repo="/data/m492zhan/review/icse24/artifact_evaluation/basex-bisect"
cd ${repo}
# 编译项目
sed -i 's|http://repo2.maven.org/maven2/|https://repo.maven.apache.org/maven2/|g' pom.xml
mvn clean > /dev/null
#mvn package -Dmaven.test.skip > /dev/null
mvn package -Dmaven.test.skip

# 复制jar文件
rm /tmp/basex.jar
find ${repo} -name 'basex-*.jar'
find ${repo}/target ${repo}/basex-core/target -name 'basex-*.jar' | grep -E 'basex-[0-9]+(\.[0-9]+)+\-SNAPSHOT.jar$' | xargs -I {} cp {} /tmp/basex.jar
if [ ! -f /tmp/basex.jar ]; then
	find ${repo}/target ${repo}/basex-core/target -name 'basex-*.jar' | grep -E 'basex-[0-9]+(\.[0-9]+)+.jar$' | xargs -I {} cp {} /tmp/basex.jar
fi

# 进入case folder执行r.sh
cd $CASE_FOLDER
echo "case folder is" $CASE_FOLDER
bash -x ./r.sh
ret=$?
cd ${repo}
git reset --hard
git clean -fd
# 根据r.sh的返回值决定当前commit是good还是bad
if [ $ret -eq 0 ]; then
    echo "returns 0"
    exit 0
else
    echo "returns 1"
    exit 1
fi
