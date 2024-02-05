#! /bin/bash

echo 'declare namespace hHOGA ="eEwEAQvxxUhWjKHRX";declare namespace jP ="eEwEAQvxxUhWjKHRX";declare namespace KHF ="CWZqMC";declare namespace z ="sSeRiEPGLlHdGsb";declare namespace gw ="SdSweVK";declare namespace IJXq ="TVAwbaYhxqErAV";declare namespace YB ="wIZDAdIQc";//*[not(subsequence(subsequence(subsequence(./(X22)[boolean(reverse(subsequence(., 1, 16)))]/(/D8/L17/C3/J13/H14,/D8/L17/Z16/N13/T17/S18/D11), 6, 1), 65, 30), 30) = ()) and (not((head(J15/V25)/has-children() != true()) = true()) or . = <A>2</A>)]' > query.xq

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


