#! /bin/bash

echo 'declare namespace zg ="IjBllXW";declare namespace OEJ ="tNfoIfbdHoOdNLImv";declare namespace dX ="mLXzumjagmH";declare namespace qcalw ="FzzZhqvXUHreJklnZEjL";declare namespace oy ="tNfoIfbdHoOdNLImv";declare namespace P ="IjBllXW";declare namespace Y ="YjgNNEKHLFTvCMQ";declare namespace nCuo ="egqTPmNBMbG";declare namespace T ="SmBqKVjXjzJdzRVRB";//*[((boolean(tail(./following::Y:P6[not(boolean(M9/A2/S7/Q19))]/self::*[not(boolean(M9/A2/C11/X16))])) castable as xs:string) and last() != 578480661) and boolean(count(reverse(.)/has-children()))]/following::*/descendant::*/ancestor::*[not(reverse(((. = <A>2</A>) and true()) and false())) and (boolean(last()) and not(not(. = <A>2</A>)) != true())]//*' > query.xq

# run saxon
target="saxon"
timeout -s 9 10s java -cp '/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/saxon-he-12.4.jar:/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xmlresolver-5.2.0/lib/*' net.sf.saxon.Query -s:./input.xml -q:./query.xq > ${target}_raw_result.xml 2>&1
ret=$?

if [ $ret != 0 ]; then
  exit 1
fi

# run basex
target="basex"
timeout -s 9 10s java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex/basex-core/target/basex-10.7-SNAPSHOT.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
ret=$?

if [ $ret != 137 ]; then
  exit 1
fi

exit 0


