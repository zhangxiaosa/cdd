#! /bin/bash

echo 'declare namespace DN ="TvoChsKBkMWrJ";declare namespace mR ="AqwLyZ";declare namespace MVjLa ="IrWcpQqbLXBwf";declare namespace eXf ="gJnSxNvKfBlig";declare namespace K ="bRwdUFNzN";declare namespace UcR ="YUzAKblGljQDr";declare namespace AdS ="TvoChsKBkMWrJ";declare namespace H ="cYNYoItjr";declare namespace CuWJo ="Dwqujoqsa";declare namespace RymwF ="AqwLyZ";declare namespace jOAI ="IrWcpQqbLXBwf";declare namespace dnWz ="XKhDuT";declare namespace z ="ezBvEILsj";//*/(/B12/L1/X10/J14,/B12/L1/X10/T30)[(not(head(subsequence(node-name(), 67)) castable as xs:string) and boolean(abs(last() mod -3219548281))) and (reverse(. = <A>2</A>) or not(((head(@f14) ! starts-with(., "y@:Sc.M(r{o{ChZAkOL83_Q J@F")) = false()) = true()))]' > query.xq

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


