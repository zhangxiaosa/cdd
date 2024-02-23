#! /bin/bash

echo 'declare namespace AWLJK ="SoXWWcjBVoxFgcouCW";declare namespace DNHD ="SoXWWcjBVoxFgcouCW";declare namespace A ="pbiHjrsS";declare namespace PhUKx ="sgSAsZVWkpUvJlPeG";declare namespace QkbQV ="sAWeLpAAvHnQZnRzOQD";declare namespace z ="TxUxAy";declare namespace GpoPz ="PYOZeSEZxwWBiEgQHh";declare namespace OUnA ="aqmbGpFA";declare namespace VHC ="JBuKthmWSDbEOOAn";//*[((boolean(./*[not(last() < -1081135595)]) and (head(.)/@id > 411068710) = true()) or (tail(reverse(./*)) = ()) = true()) or boolean(./ancestor::*[not(has-children() and false())]/GpoPz:P2)]' > query.xq

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


