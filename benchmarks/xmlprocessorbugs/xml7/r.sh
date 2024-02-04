#! /bin/bash

echo 'declare namespace XcVhp ="MDZqNWkphbnK";declare namespace xL ="eNjcLqxrGSZ";declare namespace Rjd ="MDZqNWkphbnK";declare namespace Bf ="ICGXMn";declare namespace XRXV ="xDepjA";declare namespace JbfIA ="wYJeJxRGCwLQnbKjReR";declare namespace ISVt ="YxDv";declare namespace I ="dHkFqPPU";//*[(reverse(boolean(reverse((. = <A>2</A>) != true())) ! ((. or false()) or false(),(. ! (. castable as xs:integer)) castable as xs:string)) = () and boolean(count(subsequence(reverse(./descendant-or-self::*/(/X8/C17/N11/O5/H20/H9/S12/B24)) = (), 5)))) or boolean(last() mod -9335984661) or true()]/preceding-sibling::JbfIA:W13/ancestor::W2[(./descendant::xL:Z16[not(boolean(count(subsequence(., 4, 52))))] = () or boolean(. ! .)) and (head(.) = <A>2</A> or not(head(head(node-name() ! .)) castable as xs:duration))]/JbfIA:W13[boolean(./descendant::*//L7) or not(count(boolean(.)) <= 1411478101)]//*' > query.xq

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
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex/basex-core/target/basex-10.5-SNAPSHOT.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
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


