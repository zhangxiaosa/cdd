#!/bin/bash

UTILITY="lldb"
VERSION="7.1.0"
BIN_PATH="${UTILITY}"

TIMEOUT=30

timeout -s 9 $TIMEOUT $BIN_PATH < input > out.txt 2>&1
ret=$?

if [ $ret != 139 ]; then
    exit 1
fi

tail -n 100 out.txt > temp.txt && mv temp.txt out.txt

# An array containing all the strings to check, each pattern on a new line
check_strings=(
    "lldb_private::Target::EvaluateExpression\(llvm::StringRef, lldb_private::ExecutionContextScope\*, lldb_private::SharingPtr<lldb_private::ValueObject>&, lldb_private::EvaluateExpressionOptions const&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >\*, lldb_private::ValueObject\*\) .*Target.cpp:2399.*"
    "lldb_private::CommandInterpreter::PreprocessCommand\(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&\) .*CommandInterpreter.cpp:1529.*"
    "lldb_private::CommandInterpreter::HandleCommand\(char const\*, lldb_private::LazyBool, lldb_private::CommandReturnObject&, lldb_private::ExecutionContext\*, bool, bool\) .*CommandInterpreter.cpp:1710.*"
    "lldb_private::CommandInterpreter::IOHandlerInputComplete\(lldb_private::IOHandler&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&\) .*CommandInterpreter.cpp:2828.*"
    "lldb_private::IOHandlerEditline::Run\(\) .*IOHandler.cpp:577.*"
    "lldb_private::Debugger::ExecuteIOHandlers\(\) .*Debugger.cpp:999.*"
    "lldb_private::CommandInterpreter::RunCommandInterpreter\(bool, bool, lldb_private::CommandInterpreterRunOptions&\) .*CommandInterpreter.cpp:3041.*"
    "lldb::SBDebugger::RunCommandInterpreter\(bool, bool\) .*SBDebugger.cpp:1097.*"
    "Driver::MainLoop\(\) .*Driver.cpp:686.*"
    "main .*Driver.cpp:889.*"
    # Add more patterns here if needed
)

# Index of the current string we are looking for
current_index=0

# Reading each line of the log file
while IFS= read -r line
do
    # Check if the current line contains the string at the current index
    if [[ "$line" =~ ${check_strings[$current_index]} ]]; then
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

exit 0
