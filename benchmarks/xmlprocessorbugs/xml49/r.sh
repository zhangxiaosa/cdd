#! /bin/bash

echo 'declare namespace NTH ="cO";declare namespace m ="F";declare namespace nMmjd ="F";declare namespace tz ="cO";declare namespace nO ="MRUFkQAOfJSuqkiD";//*/ancestor::tz:G18/preceding::*[not(boolean(subsequence(., 55)))]/following::*/ancestor::*//*[boolean(count(max(last() mod -8401718491))) or F13/U3/I30 = ()]/*' > query.xq

# Run Saxon and measure execution time
target="saxon"
start_time=$(date +%s.%N) # Capture start time with nanosecond precision
timeout -s 9 10s java -cp '/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/saxon-he-12.4.jar:/data/m492zhan/cdd/cdd/benchmarks/xmlprocessorbugs/xmlresolver-5.2.0/lib/*' net.sf.saxon.Query -s:./input.xml -q:./query.xq > ${target}_raw_result.xml 2>&1
ret=$?
end_time=$(date +%s.%N) # Capture end time with nanosecond precision
saxon_duration=$(echo "$end_time - $start_time" | bc) # Calculate duration in seconds

if [ $ret != 0 ]; then
  exit 1
fi

# Run BaseX with a fixed 10s timeout and measure execution time
target="basex"
start_time=$(date +%s.%N) # Capture start time with nanosecond precision
timeout -s 9 10s java -cp "/data/m492zhan/review/icse24/artifact_evaluation/basex/basex-core/target/basex-10.7-SNAPSHOT.jar" org.basex.BaseX -i input.xml query.xq > ${target}_raw_result.xml 2>&1
ret=$?
end_time=$(date +%s.%N) # Capture end time with nanosecond precision
basex_duration=$(echo "$end_time - $start_time" | bc) # Calculate duration in seconds

# Compare BaseX execution time to Saxon's, checking if BaseX's time is more than 5 times Saxon's
if [ $(echo "$basex_duration <= 5 * $saxon_duration" | bc) -eq 1 ]; then
  exit 1
fi

exit 0
