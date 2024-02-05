#! /bin/bash

echo 'declare namespace Aa ="saEqczELwiDr";declare namespace eTA ="NrJTEVj";declare namespace A ="xBgwTrJDHDdbRMXBx";declare namespace ycMC ="iFMLJyyqIYnZTtwzRjQf";declare namespace feMuH ="WyfHLLUDdrTuJjNxgxH";declare namespace VrN ="X";declare namespace CrEt ="iF";declare namespace EU ="fLxguhNPLNhmUoaCLj";declare namespace yAcX ="QcMEgKoMhEpBY";declare namespace CIIz ="NrJTEVj";declare namespace s ="xBgwTrJDHDdbRMXBx";declare namespace ibfTi ="saEqczELwiDr";//*/ancestor::*[reverse(boolean(reverse(B29))) or not(boolean(normalize-space(@e9)))]/CIIz:G5/preceding::VrN:U5[not((boolean(tail(./(/U13/S11/E16/F5/T6/H7/U5))) and false()) ! head(.))]/parent::*[(boolean(last()) or ((head(head(head(head(subsequence(., 2))/node-name()))) ! .) castable as xs:duration)) or (reverse(boolean(.)) = false()) = false()]/Aa:T31[boolean((node-name() ! count(subsequence(., 90))) + -299134339) and (boolean(last()) and not(boolean(subsequence(tail(./preceding-sibling::Aa:E3), 2))))]/parent::VrN:H7[boolean(./*//*[not(boolean(O31))])]/*' > query.xq

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


