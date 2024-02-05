#! /bin/bash

echo 'declare namespace hOeC ="ehNePQkrYdfiSp";declare namespace uOARN ="rYyuJJTlb";declare namespace MTRM ="CQnF";declare namespace imn ="AUeKnDIMIWvg";declare namespace s ="YWPmpsyWWDhdrrbnrCDa";declare namespace CnNX ="senmVXwihCPOenxR";declare namespace y ="bvhaWsczC";declare namespace yQzO ="TjQVCS";declare namespace VcOnc ="azcIqeTaaO";declare namespace G ="vhgncQXSLMnsCH";declare namespace Shp ="ehNePQkrYdfiSp";//*[not(head(./child::Shp:W7/preceding::*)/has-children() != true())]' > query.xq

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


