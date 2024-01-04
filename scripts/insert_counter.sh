#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <script_file> <log_file>"
    exit 1
fi

# Assign the paths of the script file and log file to variables
script_file=$1
log_file=$2

# Check if the script file exists
if [ ! -f "$script_file" ]; then
    echo "Script file not found: $script_file"
    exit 1
fi

# Check if the log file exists, if not, inform that a new file will be created
if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file, a new log file will be created."
fi

# Check if '#! /bin/bash' or '#!/bin/bash' exists in the script file
if grep -qE '^#! ?/bin/bash$' "$script_file"; then
    # If found, insert 'date >> log_file' after this line
    sed -i "/^#! ?\/bin\/bash$/a date >> $log_file" "$script_file"
else
    # If not found, insert 'date >> log_file' at the beginning of the file
    sed -i "1i date >> $log_file" "$script_file"
fi
