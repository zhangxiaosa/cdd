#! /bin/bash

echo 'declare namespace bE ="W";declare namespace Di ="pQGerHlQuxQS";declare namespace qlM ="xMeYiN";declare namespace EJ ="Le";declare namespace g ="vsyoNurscvoByjfzOUT";declare namespace IXwX ="YqKOjBvluTSCWSGVJ";declare namespace CEJdX ="ykpOHQCm";declare namespace Pefdr ="NHAfJRREluShmPTlY";declare namespace a ="rLyNogjOjQKxIU";declare namespace U ="pQGerHlQuxQS";declare namespace FW ="W";declare namespace LvSCD ="zQTvGrDRfGTnwaCg";//*[(boolean(subsequence(subsequence(., 18, 51), 68)) or not(reverse(starts-with(head(.//FW:E2[not((node-name()) castable as xs:string)]/self::*)/@j3, "b")))) and not(has-children(.) != true())]' > query.xq

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
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex-7165a07.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
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


