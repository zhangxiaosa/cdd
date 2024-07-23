import os
import shutil
import subprocess
import tempfile
import argparse
import concurrent.futures
import random
import threading

lock = threading.Lock()

def copy_files_to_tmp(input_file, script_file):
    tmp_dir = tempfile.mkdtemp()
    shutil.copy(input_file, os.path.join(tmp_dir, 'input'))
    shutil.copy(script_file, os.path.join(tmp_dir, 'r.sh'))
    return tmp_dir

def run_script(script_path, cwd):
    result = subprocess.run(['bash', script_path], capture_output=True, cwd=cwd)
    return result.returncode

def remove_lines(input_path, start_line, num_lines):
    with open(input_path, 'r', encoding='latin1') as file:
        lines = file.readlines()

    modified_lines = [line for i, line in enumerate(lines) if i < start_line or i >= start_line + num_lines]

    with open(input_path, 'w', encoding='latin1') as file:
        file.writelines(modified_lines)

def remove_random_lines(input_path, num_lines, total_lines):
    with open(input_path, 'r', encoding='latin1') as file:
        lines = file.readlines()

    if num_lines >= total_lines:
        raise ValueError("num_lines must be less than the total number of lines in the file")

    random_indices = random.sample(range(total_lines), num_lines)

    random_indices_set = set(random_indices)
    modified_lines = [line for i, line in enumerate(lines) if i not in random_indices_set]

    with open(input_path, 'w', encoding='latin1') as file:
        file.writelines(modified_lines)

    return random_indices

def log_result(log_path, removed_lines, success):
    with lock:
        with open(log_path, 'a') as log_file:
            #log_file.write(f"Removed lines {removed_lines}: {'Success' if success else 'Failure'}\n")
            log_file.write(f"Removed {len(removed_lines)} lines: {'Success' if success else 'Failure'}\n")

def process_window(input_file, script_file, num_lines, total_lines, log_file):
    tmp_dir = copy_files_to_tmp(input_file, script_file)
    input_tmp_path = os.path.join(tmp_dir, 'input')

    start_line = random.randint(0, total_lines - num_lines)
    remove_lines(input_tmp_path, start_line, num_lines)
    removed_lines = list(range(start_line + 1, start_line + num_lines + 1))

    script_path = os.path.join(tmp_dir, 'r.sh')

    result = run_script(script_path, cwd=tmp_dir)
    success = result == 0

    log_result(log_file, removed_lines, success)

    shutil.rmtree(tmp_dir)

    return removed_lines, success

def process_random_lines(input_file, script_file, num_lines, total_lines, log_file):
    tmp_dir = copy_files_to_tmp(input_file, script_file)
    input_tmp_path = os.path.join(tmp_dir, 'input')

    removed_lines = remove_random_lines(input_tmp_path, num_lines, total_lines)
    script_path = os.path.join(tmp_dir, 'r.sh')

    result = run_script(script_path, cwd=tmp_dir)
    success = result == 0

    log_result(log_file, removed_lines, success)

    shutil.rmtree(tmp_dir)

    return removed_lines, success

def main(input_file, script_file, num_lines, jobs, attempts, mode):
    log_file = f"{num_lines}lines_{jobs}jobs_{attempts}attempts_{mode}mode.log"

    with open(log_file, 'w') as log_file_clear:
        log_file_clear.write("Log of removed lines and results:\n")

    with open(input_file, 'r', encoding='latin1') as file:
        original_lines = file.readlines()
    total_lines = len(original_lines)

    if total_lines < num_lines:
        print(f"File has fewer than {num_lines} lines. Exiting.")
        return

    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as executor:
        futures = []
        for _ in range(attempts):
            if mode == 'slide':
                futures.append(executor.submit(process_window, input_file, script_file, num_lines, total_lines, log_file))
            elif mode == 'random':
                futures.append(executor.submit(process_random_lines, input_file, script_file, num_lines, total_lines, log_file))

        try:
            for future in concurrent.futures.as_completed(futures):
                removed_lines, success = future.result()
                print(f"Progress: {'Success' if success else 'Failure'}")
        except KeyboardInterrupt:
            print("Process interrupted by user. Cleaning up...")
            executor.shutdown(wait=False)
            raise

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process input file and script with random or sliding window line removal.')
    parser.add_argument('input_file', type=str, help='Path to the input file')
    parser.add_argument('script_file', type=str, help='Path to the r.sh file')
    parser.add_argument('num_lines', type=int, help='Number of lines to remove')
    parser.add_argument('--jobs', type=int, default=1, help='Number of threads to use')
    parser.add_argument('--attempts', type=int, default=10, help='Number of attempts to make')
    parser.add_argument('--mode', choices=['slide', 'random'], required=True, help='Mode of line removal: "slide" for sliding window, "random" for random lines')

    args = parser.parse_args()

    main(args.input_file, args.script_file, args.num_lines, args.jobs, args.attempts, args.mode)

