#! /bin/bash

echo 'declare namespace ecX ="WxfbursJJgi";declare namespace iNkYu ="WxfbursJJgi";declare namespace yxQ ="WxfbursJJgi";//*[((reverse(position()) >= 1467714880 or boolean((head(J11/G21/N6/U33)/position() idiv -419751184) - -1688438354)) or boolean(boolean(.))) and not(boolean(subsequence(./parent::iNkYu:X10/ecX:X13, 23, 10)))]/parent::*[boolean(head(count(./*[not(count(.) > 1495384816)]/descendant-or-self::iNkYu:G7)))]/*[boolean(count(T1/V7/K18)) or (not(.//ecX:V19[not(head(.) = <A>2</A>)]/ancestor-or-self::N2 = ()) and (boolean(abs(head(min(count(.//ecX:O28))))) or boolean(math:sin(reverse(.)/node-name() ! count(.)))))]/descendant::*[boolean(last())]' > query.xq

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


