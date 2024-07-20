import subprocess
import os

# 复制当前环境变量
env = os.environ.copy()

# 定义命令和工作目录
command = './r.sh'
# cwd = "/home/coq/cdd/benchmarks/utilitybugs/look-8.2/input.20240311_184945/tests/a0_assert"

# 使用Popen执行命令
process = subprocess.Popen(
    command,
    #cwd=cwd,
    shell=True,
    env=env,
    executable='/bin/bash',
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True
)

# 等待进程结束并获取输出
stdout, stderr = process.communicate()

# 打印结果
print("Return code:", process.returncode)
print("STDOUT:")
print(stdout)
print("STDERR:")
print(stderr)

