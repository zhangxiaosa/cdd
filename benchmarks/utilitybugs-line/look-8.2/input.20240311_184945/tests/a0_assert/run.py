import subprocess
import os

env = os.environ.copy()

# Run the subprocess and capture output
result = subprocess.run(
    #['/home/coq/cdd/benchmarks/utilitybugs/look-8.2/r.sh', '/home/coq/cdd/benchmarks/utilitybugs/look-8.2/input.20240311_184945/tests/a0_assert/input'],
    ['./r.sh'],
    #cwd="/home/coq/cdd/benchmarks/utilitybugs/look-8.2/input.20240311_184945/tests/a0_assert",
    check=False,
    shell=True,
    env=env,
    executable='/bin/bash',
    capture_output=True,
    text=True # This will ensure the outputs are strings
)

# Print the return code, stdout, and stderr
print("Return code:", result.returncode)
print("STDOUT:")
print(result.stdout)
print("STDERR:")
print(result.stderr)

