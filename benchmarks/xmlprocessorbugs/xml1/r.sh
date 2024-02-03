#! /bin/bash

# run saxon
java -cp '../saxon-he-12.4.jar:../xmlresolver-5.2.0/lib/*' net.sf.saxon.Query -s:./input.xml -q:./query.xq > saxon_raw_result.xml 2>&1
ret=$?

if [ $ret != 0 ]; then
  exit 1
fi

# process saxon result
grep -o 'id="[^"]*"' saxon_raw_result.xml | sed 's/id="//g' | sed 's/"//g' > saxon_processed_result.txt

# run basex
java -cp /data/m492zhan/review/icse24/artifact_evaluation/basex/basex-core/target/basex-10.5-SNAPSHOT.jar org.basex.BaseX -i input.xml query.xq > basex_raw_result.xml 2>&1
ret=$?

if [ $ret != 0 ]; then
  exit 1
fi

# process basex result
grep -o 'id="[^"]*"' basex_raw_result.xml | sed 's/id="//g' | sed 's/"//g' > basex_processed_result.txt

# diff
if diff saxon_processed_result.txt basex_processed_result.txt > /dev/null 2>&1; then
    # files are different
    exit 1
fi

exit 0


