#! /bin/bash

echo 'declare namespace ZTwz ="nRK";declare namespace bYL ="vLwo";declare namespace lt ="O";declare namespace z ="IYuFJqIMDFUWhgZ";declare namespace JqTTh ="vLwo";declare namespace Yr ="O";declare namespace Z ="FKncjODlTvGWlXclon";declare namespace y ="nRK";declare namespace sqB ="pQS";declare namespace xkBL ="zdWUKRyuNHLZN";declare namespace IWqUE ="rQTchFqrskKRCfuxs";//*[boolean(./ZTwz:S26[not(boolean(position() idiv 91032079))]) and (boolean(.//*[not(last() < -1794714260)]/parent::*) or head(tail(subsequence(starts-with(name(), ",I w{") != true(), 3))))]' > query.xq

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
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex-5b34391.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
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


