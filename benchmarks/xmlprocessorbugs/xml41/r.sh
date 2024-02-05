#! /bin/bash

echo 'declare namespace pKF ="xetXxsIEZCm";declare namespace VRQa ="MdXTGjasISGaUOcrRIK";declare namespace oj ="tSbBOiQpUDJmCNBjmfHs";declare namespace K ="MdXTGjasISGaUOcrRIK";declare namespace oN ="xetXxsIEZCm";//*[(boolean(count(count(tail(./ancestor::*[not(boolean(U1/N33))])) ! (avg(.),(. != -1673911725) and true()))) or boolean(head(reverse(subsequence(subsequence(., 53), 4, 67))))) and (subsequence(reverse(. ! (@d17 ! (minutes-from-duration(.),seconds-from-duration(.)),.)), 1, 8) castable as xs:string)]' > query.xq

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


