#! /bin/bash

echo 'declare namespace Mt ="Ei";declare namespace Of ="Ei";declare namespace k ="fYtelijRND";declare namespace jT ="rAfbWqNsFjEvsSwVFIFu";//*[((contains-token(name(), "m_3") and reverse((. = <A>2</A>) or false())) or not(head(not(boolean(.))) or false())) and not(boolean(count(subsequence(tail(reverse(subsequence(node-name(), 31, 16) ! subsequence(reverse(.), 47))), 59))))]/*/following::*[boolean(reverse(count(./parent::k:Y8//*) - -2137490843))]/ancestor::*//*[(not(boolean(.)) castable as xs:double) and not(. ! reverse(. = <A>2</A>))]/ancestor-or-self::*//*' > query.xq

# run saxon
target="saxon"
timeout -s 9 10s java -cp '/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/saxon-he-12.4.jar:/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xmlresolver-5.2.0/lib/*' net.sf.saxon.Query -s:./input.xml -q:./query.xq > ${target}_raw_result.xml 2>&1
ret=$?

if [ $ret != 0 ]; then
  exit 1
fi

# run basex
target="basex"
timeout -s 9 10s java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex/basex-core/target/basex-10.5-SNAPSHOT.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
ret=$?

if [ $ret != 137 ]; then
  exit 1
fi

exit 0


