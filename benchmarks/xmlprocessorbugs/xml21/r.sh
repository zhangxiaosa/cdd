#! /bin/bash

echo 'declare namespace xz ="l";declare namespace BqODi ="dmtHNzqxuDcN";declare namespace RP ="FEFOjGjiksmRT";declare namespace irGkx ="l";declare namespace NGIrh ="vtAZoRSgnlhDsKjj";declare namespace voouy ="TIGejOhlbGDUb";declare namespace va ="CEdzsnLDzDYRTiulDxM";declare namespace ghcX ="Iiu";declare namespace Sfbq ="rrZBSaUcDTjrLgOA";declare namespace DVvF ="dmtHNzqxuDcN";declare namespace eASS ="Ui";declare namespace o ="v";//*[(not((head(Y31)/has-children() != true()) != false()) and not(boolean(./(Y31,/E1/Z13/P1/H8/W5/T7/J14)//Sfbq:I23))) and boolean(count(last() castable as xs:double))]' > query.xq

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


