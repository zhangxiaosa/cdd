#! /bin/bash

echo 'declare namespace fv ="AHXRyjLbv";declare namespace hz ="AHXRyjLbv";declare namespace iTdJe ="AHXRyjLbv";//*[boolean(count(boolean((. = <A>2</A>) castable as xs:string)) mod 9787388241) and (not(boolean(boolean(boolean(./(/I25/P20/S20/T7/H15/G16/R10)[boolean(count(reverse(subsequence(node-name(), 5, 26))))]/child::fv:D10)))) and not(boolean(head(reverse(./(/I25/P20/S20/T7/H15/G16/R10)[boolean(math:cos(. ! position()))])))))]' > query.xq

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
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex-bisect/basex-core/target/basex.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
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


