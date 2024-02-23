#! /bin/bash

echo 'declare namespace ciEJU ="EsZLbBUbSMkZrB";declare namespace lDXQt ="EsZLbBUbSMkZrB";declare namespace F ="rbOVGyba";declare namespace b ="bTmsLz";declare namespace TfCCZ ="rzCUqyw";declare namespace z ="BRt";declare namespace OqDbe ="rB";//*[not(boolean(abs(min(sum(boolean(.) ! (subsequence(., 66) ! count(.)))))))]//*[(boolean(tail(subsequence(./(/E21/L18/L9/C10/V26), 40, 33))) or (count(name() <= "VOhlq8") < 974223853 or boolean(head(subsequence(position(), 2)) < 1936496908))) and not((./ancestor::*/descendant::W3 = ()) or false())]/preceding::OqDbe:X11/following::*[boolean(name()) or ((boolean(subsequence(reverse(.//F:K7), 44)) and boolean(math:cos(max(count(.))))) and boolean(last() * 4))]/descendant-or-self::b:Y17/following::*[boolean(.//*/*)]//*[((boolean(./(K7)/OqDbe:I8[. ! (local-name() != "fQ)iwH,%L um")]) and boolean(subsequence(./*[not(starts-with(local-name(), "*k:zY! "))], 24))) and subsequence(., 44) = ()) or not(head(subsequence(./*/preceding::*[boolean(name())] = (), 6)))]' > query.xq

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


