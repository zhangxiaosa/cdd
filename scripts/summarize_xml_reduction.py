import os
import re
import sys
import csv

BENCHMARK_LIST = ['xml10', 'xml12', 'xml15', 'xml17', 'xml18', 'xml19', 'xml2', 'xml20', 'xml21', 'xml22', 'xml23',
                  'xml26', 'xml27', 'xml3', 'xml30', 'xml31', 'xml32', 'xml33', 'xml36', 'xml38', 'xml39',
                  'xml4', 'xml41', 'xml42', 'xml43', 'xml50', 'xml51', 'xml52', 'xml53', 'xml54', 'xml55',
                  'xml56', 'xml58', 'xml59', 'xml60', 'xml61', 'xml62', 'xml63', 'xml64', 'xml65', 'xml66', 'xml67',
                  'xml68', 'xml69', 'xml7', 'xml70', 'xml71', 'xml72', 'xml73', 'xml74', 'xml75', 'xml76', 'xml77',
                  'xml78', 'xml79', 'xml80', 'xml81', 'xml9']
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


def get_token_num(file):
    cmd = "java -jar ~/cdd/tools/token_counter.jar %s" % file
    proc = os.popen(cmd)
    output = proc.read()

    # Split the output into lines and get the last line
    lines = output.strip().split('\n')
    last_line = lines[-1] if lines else ''

    # Search for a number in the last line
    match = re.search(r'(\d+)', last_line)
    if match:
        return match.group(1)
    else:
        return None


def get_iteration(log_file):
    pattern = re.compile(r"Iteration #(\d+)")
    with open(log_file, 'r') as file:
        lines = file.readlines()
        for line in reversed(lines):
            match = pattern.search(line)
            if match:
                return int(match.group(1)) + 1

    return None


def get_test_num(log_file):
    with open(log_file, "r") as f:
        queries = f.readlines()
    return len(queries)


with open(os.path.join(RESULT_PATH, 'summary.csv'), 'w', newline='') as csvfile:
    CSV_WRITER = csv.writer(csvfile)
    CSV_WRITER.writerow(["target", "time", "token num", "iteration", "test num"])

    for target in BENCHMARK_LIST:
        row = [target]  # Initialize row with target as the first column
        collect_path = os.path.join(RESULT_PATH, "result_" + target)
        if not os.path.exists(collect_path):
            print("%s is not available" % target)
            row.extend([None, None, None, None])
            CSV_WRITER.writerow(row)  # Write only target if not available
            continue
        final_program_path = os.path.join(collect_path, "tests", "input.xml")
        if os.path.isfile(final_program_path):
            token_num = get_token_num(final_program_path)
            log_file = os.path.join(RESULT_PATH, "log_" + target + ".txt")
            query_stat_file = os.path.join(RESULT_PATH, "query_stat_" + target + ".txt")
            time = get_time_from_log(log_file)
            iteration = get_iteration(log_file)
            test_num = get_test_num(query_stat_file)

            print("target: %s: time: %s, token num: %s, iteration: %d, test num: %d"
                  % (target, time, token_num, iteration, test_num))
            row.extend([time, token_num, iteration, test_num])
        else:
            print("%s: input.xml not available" % target)
            row.extend([None, None, None, None])

        CSV_WRITER.writerow(row)
