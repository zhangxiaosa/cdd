#! /bin/bash

echo 'declare namespace F ="RWOTt";declare namespace dzB ="ytklHmYdvQdRV";declare namespace bwY ="uNCDHFiiFTkJBkmhaoa";declare namespace ae ="AKPs";declare namespace yoTfa ="RWOTt";declare namespace maA ="ytklHmYdvQdRV";declare namespace An ="TTDBscggAXoDlGvAXBN";declare namespace buj ="BNaSKawBKVO";declare namespace UzlEW ="uNCDHFiiFTkJBkmhaoa";declare namespace HwUl ="KsEEnVZtVPJ";//*[not(head(subsequence(node-name(), 57)) ! (. castable as xs:double)) and (boolean(subsequence(./(H27)[boolean(last())]/(K27,B22)[boolean(@q18)], 1)) or boolean(((@u9 ! (. or true())) = false()) ! (not(.) = true())))]' > query.xq

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


