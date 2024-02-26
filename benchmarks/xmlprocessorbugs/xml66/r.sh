#! /bin/bash

echo 'declare namespace I ="uelhxzesNErXHBPykNd";declare namespace exznS ="hGBZZOL";declare namespace G ="SzkN";declare namespace hr ="TcJAfSrFQuTAdXMvFrQ";declare namespace nBGl ="XpAyYZGQSJKhZq";declare namespace yu ="uelhxzesNErXHBPykNd";declare namespace zg ="byJJkclgtvLLMuiqe";declare namespace jP ="LKTKjt";declare namespace fTuI ="hGBZZOL";//W24[((boolean(subsequence(./exznS:J25[boolean(position())], 53, 1)) or not(boolean(./(J25)[boolean(K15/E15/S14/N33)]))) and not(boolean(tail(./(J25))))) and boolean(count(reverse(.//fTuI:J25)))]' > query.xq

# run saxon
target="saxon"
java -cp '/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/saxon-he-12.4.jar:/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xmlresolver-5.2.0/lib/*' net.sf.saxon.Query -s:./input.xml -q:./query.xq > ${target}_raw_result.xml 2>&1
ret=$?

if [ $ret != 0 ]; then
  exit 1
fi

# process saxon result
grep -o 'id="[^"]*"' ${target}_raw_result.xml | sed 's/id="//g' | sed 's/"//g' | grep -v '^[[:space:]]*$' > ${target}_processed_result.txt

# run basex
target="basex"
#java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex-bisect/basex.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
#java -cp "/tmp/basex.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex-2f1fb03.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
ret=$?

if [ $ret != 0 ]; then
  exit 1
fi

# process basex result
grep -o 'id="[^"]*"' ${target}_raw_result.xml | sed 's/id="//g' | sed 's/"//g' | grep -v '^[[:space:]]*$' > ${target}_processed_result.txt

# diff
if diff saxon_processed_result.txt basex_processed_result.txt > /dev/null 2>&1; then
    # files are different
    exit 1
fi

exit 0


