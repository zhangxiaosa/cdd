#!/bin/bash

UTILITY="lldb"
VERSION="7.1.0"
BIN_PATH="${UTILITY}"

TIMEOUT=30

timeout -s 9 $TIMEOUT valgrind $BIN_PATH < input > out.txt 2>&1

# An array containing all the strings to check, each pattern on a new line
check_strings=(
    "Process terminating with default action of signal 11 (SIGSEGV): dumping core"
    "fatal_error (dl-error-skeleton.c:78)"
    "_dl_signal_exception (dl-error-skeleton.c:102)"
    "_dl_map_object_deps (dl-deps.c:612)"
    "dl_main (rtld.c:1733)"
    "_dl_sysdep_start (dl-sysdep.c:253)"
    "_dl_start_final (rtld.c:415)"
    "_dl_start (rtld.c:522)"
    # Add more patterns here if needed
)

# Index of the current string we are looking for
current_index=0

# Reading each line of the log file
while IFS= read -r line
do
    # Check if the current line contains the string at the current index
    if [[ "$line" == *"${check_strings[$current_index]}"* ]]; then
        ((current_index++))

        # Exit if all strings have been found
        if [ $current_index -ge ${#check_strings[@]} ]; then
            break
        fi
    fi
done < out.txt

# If not all strings were found, output a message and exit with code 1
if [ $current_index -lt ${#check_strings[@]} ]; then
    exit 1
fi

rm vgcore.*
exit 0
