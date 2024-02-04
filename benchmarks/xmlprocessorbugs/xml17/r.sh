#! /bin/bash

echo 'declare namespace UlCh ="ElotxYnNoUTttHK";declare namespace vaE ="ElotxYnNoUTttHK";declare namespace Rsp ="emBYhiGpnpGx";declare namespace CSD ="dItqGnZvHiRfoSsLR";declare namespace m ="tPeVOcxBnlJqxDKsRoCl";declare namespace Mb ="KFbdG";declare namespace DLxOO ="GbI";declare namespace YIb ="BmtbCeGoPjsXRNc";declare namespace vK ="urlinMZsLQEDbWGO";declare namespace iS ="rCwnqaKlfoNICnmLK";//*/(G29,/X14/P4/T7/Y20/O3/M1/C15/L2/J9/Y5/J7,F10)[((boolean(tail(reverse(reverse(R16/A12/R24)))) or lower-case(lower-case(namespace-uri-from-QName(. ! reverse(.)/node-name()))) ! (translate(., "of", "n5LR \ bVUR PfoC") castable as xs:string)) or has-children()) and ((@f3 ! boolean(count(.))) != true()) != true()]' > query.xq

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


