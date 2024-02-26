#! /bin/bash

echo 'declare namespace rQ ="gXHDT";declare namespace BwPx ="IUI";declare namespace Qd ="MIhQZukWUDmkidz";declare namespace wOnb ="RsiphcBuV";declare namespace ePi ="dSSDRLZMyifEDaW";declare namespace pVB ="xBU";declare namespace HUaAy ="lTXQYfgMjmqMK";declare namespace GvJ ="dIRtmbUL";declare namespace UUS ="gXHDT";declare namespace JYSv ="YvkVafZOcjIXaOxBV";declare namespace j ="IUI";//ePi:I15/*[(boolean(name()) or boolean(lower-case(reverse(local-name())))) or boolean(head(./descendant-or-self::ePi:M27))]/(/U13/A10/R5/V5/J3/P11/M9/C16/I15/Q29,/U13/A10/R5/V5/J3/P11/M9/C16/I15/M27)/descendant-or-self::*/*/ePi:P22/ePi:Z22[(head((count(.) > -1757427944) ! .) and boolean(substring(name(), 9)) != true()) and (((boolean(count(.)) != false()) = true()) and false() or boolean(count(./(/U13/X9/M12/W15/I27)[boolean(@id * 377)]/(X1,/U13/P5/U16/R21)) - -714622165 mod -10185109121))]' > query.xq

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
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex/basex-core/target/basex-10.7-SNAPSHOT.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
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


