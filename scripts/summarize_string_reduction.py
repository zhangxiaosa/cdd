import os
import re
import sys
import csv

BENCHMARK_LIST = ['dc-1.3', 'flex-2.5.39', 'gdb-8.1', 'lldb-7.1.0', 'troff-1.22.3']
RESULT_PATH = sys.argv[1]

def get_time_from_log(log_file):
    with open(log_file, 'r') as fopen:
        lines = fopen.readlines()
    line_of_time = lines[-1]
    match = re.search(r'execution time:\s*(\d+)(?:\.\d+)?', line_of_time)
    if match:
        # keep the integer part and remove the decimal part
        return match.group(1)
    else:
        return None

def get_char_num(file):
    return os.path.getsize(file)

# def get_iteration(res_path):
#     return len(os.listdir(res_path))

def get_test_num(res_path):
    return file_count(res_path, "input")

def file_count(path, extension):
    count = 0
    for _, _, files in os.walk(path):
        count += sum(f.endswith(extension) for f in files)
    return count

with open(os.path.join(RESULT_PATH, 'summary.csv'), 'w', newline='') as csvfile:
    CSV_WRITER = csv.writer(csvfile)
    CSV_WRITER.writerow(["target", "time", "token num", "test num"])

    for target in BENCHMARK_LIST:
        row = [target]  # Initialize row with target as the first column
        collect_path = os.path.join(RESULT_PATH, "result_" + target)
        if not os.path.exists(collect_path):
            print("%s is not available" % target)
            row.extend([None, None, None, None])
            CSV_WRITER.writerow(row)  # Write only target if not available
            continue
        final_program_path = os.path.join(collect_path, "input")
        if os.path.isfile(final_program_path):
            char_num = get_char_num(final_program_path)
            log_file = os.path.join(RESULT_PATH, "log_" + target + ".txt")
            time = get_time_from_log(log_file)
            intermidiate_result_path = os.path.join(collect_path, "tests")
            # iteration = get_iteration(intermidiate_result_path)
            test_num = get_test_num(intermidiate_result_path)

            print("target: %s: time: %s, token num: %s, test num: %d"
                  % (target, time, char_num, test_num))
            row.extend([time, char_num, test_num])
        else:
            print("%s: small.c not available" % target)
            row.extend([None, None, None, None])

        CSV_WRITER.writerow(row)
