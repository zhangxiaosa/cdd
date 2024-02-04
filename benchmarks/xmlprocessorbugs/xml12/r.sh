#! /bin/bash

echo 'declare namespace oD ="AhGBUjZOWYyiF";declare namespace qS ="HzBUDWUjpyEDSPQ";declare namespace nfw ="LJdwWr";declare namespace Hs ="AhGBUjZOWYyiF";declare namespace z ="HzBUDWUjpyEDSPQ";declare namespace CooQr ="ZkUbXTeSKZkQYoezodZ";declare namespace yY ="LJdwWr";declare namespace LHIn ="wCkrH";declare namespace gJhWW ="FKPcDafWopwZyDHHyU";//*[boolean(. ! .)]/following-sibling::*[not(((subsequence(has-children(), 3) = ()) or true()) and false()) and not(boolean(./(/R12/A14/G14/D10/T4/G14/R19/F3/K27)/parent::nfw:U13[. = <A>2</A>]))]/ancestor::*/child::z:I21[((boolean(subsequence(., 2, 42)) != false()) != true()) != false() and (not(boolean(tail(subsequence(./*, 22)))) and boolean(position() + 676432593))]//*[not(head(subsequence(boolean(./parent::*), 53))) and boolean(./ancestor-or-self::*//*)]/ancestor-or-self::*' > query.xq

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


