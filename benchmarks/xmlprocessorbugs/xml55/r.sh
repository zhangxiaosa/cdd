#! /bin/bash

echo 'declare namespace Y ="UWjuezyDWoyZbDEERxK";declare namespace JvQ ="fNgsckh";declare namespace Az ="MPW";declare namespace KDyBg ="qNideBQSoJCRQUQlyc";declare namespace ttL ="eAqToikXRUdMoxVIJVO";declare namespace SXI ="tyxAzNhEvi";declare namespace xyP ="Mo";declare namespace lGZ ="UWjuezyDWoyZbDEERxK";declare namespace fItpY ="tdcGmiUik";declare namespace iHmBo ="prSmyfiP";//*[not(boolean(has-children()) != true()) or (boolean(sum(@id)) and boolean(I6/F5/L25))]' > query.xq

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
java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex-bisect/basex-core/target/basex.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
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


