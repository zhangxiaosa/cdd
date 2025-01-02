# Artifact for "Toward a Better Understanding of Probabilistic Delta Debugging"

## Introduction

Thank you for evaluating this artifact!

To evaluate this artifact, a Linux machine with [docker](https://docs.docker.com/get-docker/) installed is needed.

### Notes

- All the experiments take long time to finish, so it is recommended to use tools like screen and tmux to manage sessions if the experiments are run on remote server. We also provide flags for multi-processing.

- The evaluation results may not exactly the same as shown in the paper, because both ProbDD and CDD are affected by randomness. Replicating the experiments for multiple times will mitigate such impact. However, the deviation should be trivial, and the results should still support the original claims in the paper.

### Docker Environment Setup

1. If docker is not installed, install it by following the [instructions](https://docs.docker.com/get-docker/).
2. Install the docker image.

   ```bash
   docker pull m492zhan/cdd:latest
   # This step might takes a while, mainly depending on the network bandwidth. It also takes up much disk space (nearly 80GB)
   ```

3. Start a container.

   ```bash
   docker container run --cap-add SYS_PTRACE --interactive --tty m492zhan/cdd:latest /bin/bash
   # You should be at /tmp after the above command finishes
   # Your user name should be `coq` and all the following command are executed in docker

   # the root folder of the project is /home/coq/cdd
   cd /home/coq/cdd
   ```

### Benchmark Suites

In this project,
benchmark suite are in folder `./benchmarks`.

1. `./benchmarks/compilerbugs`(BM-C): 20 cases triggering C compiler bugs.

2. `./benchmarks/debloating`(BM-DBT): 10 cases for software debloating.

3. `./benchmarks/xmlprocessorbugs`(BM-XML): 46 cases triggering XML processor bugs.

### Build the Tools

In the container, run the following commands to build the tools.

```bash
cd /home/coq/cdd
./scripts/build_hdd.sh
./scripts/build_chisel.sh
```

### Run ddmin, ProbDD and CDD on each benchmark suite.

##### Evaluate DDMIN, ProbDD and CDD on BM-C.

   ```bash
   cd /home/coq/cdd

   # ddmin (around 100 hours given single process)
   ./scripts/run_program_reduction.sh --args_for_picireny "--dd ddmin --init-probability 0.1"

   # probdd (around 50 hours given single process)
   ./scripts/run_program_reduction.sh --args_for_picireny "--dd probdd --init-probability 0.1"

   # evaluate CDD (around 50 hours given single process)
   ./scripts/run_program_reduction.sh --args_for_picireny "--dd cdd --init-probability 0.1"

   # To evaluate on multiple benchmarks concurrently, use the flag --max_jobs, for example:
   ./scripts/run_program_reduction.sh --args_for_picireny "--dd ddmin --init-probability 0.1" --max_jobs "8"

   # To evaluate a specific benchmark, use the flag --benchmark, for example:
   ./scripts/run_program_reduction.sh --args_for_picireny "--dd ddmin --init-probability 0.1" --benchmark "clang-22382"
   ```

Results and log.

   Note that every time you start `./run_program_reduction.sh`, a folder named by current timestamp is created in
   `~/cdd/results/compilerbugs`.
   For instance, if current time is 2023/09/12,23:06:25, all results produced by this run will be saved in `~/cdd/results/compilerbugs/20230912230625/`. Besides, there is a config.txt recording the options in this run, under the folder `20230912230625`.

   Summarize the result in this run.

   ```bash
   cd ~/cdd/results/compilerbugs/20230912230625/
   python ~/cdd/script/summarize_program_reduction.py .
   ```

   Then, file `summary.csv` will be saved in `~/cdd/results/compilerbugs/20230912230625/`.
   In `summary.csv`, data such as time, final size and query number for each benchmark is displayed.

##### Evaluate ddmin, ProbDD and CDD on BM-DBT.

   Similar to how we evaluate algorithms in BM-C, just run `./script/run_chisel.sh` with correct options.

   ```bash
   # ddmin (around 180 hours given single process)
   ./scripts/run_software_debloating.sh --args_for_chisel "--algorithm ddmin --init_probability 0.1"
   # ProbDD (around 120 hours given single process)
   ./scripts/run_software_debloating.sh --args_for_chisel "--algorithm probdd --init_probability 0.1"
   # CDD (around 120 hours given single process)
   ./scripts/run_software_debloating.sh --args_for_chisel "--algorithm cdd --init_probability 0.1"

   # To run multiple benchmarks concurrently, use --max_jobs
   ./scripts/run_software_debloating.sh --args_for_chisel "--algorithm ddmin --init_probability 0.1" --max_jobs "8"
   # To run a specific benchmark, use --benchmark
   ./scripts/run_software_debloating.sh --args_for_chisel "--algorithm ddmin --init_probability 0.1" --benchmark "mkdir-5.2.1"
   ```

   Similarly, results will be stored in a folder named by current timestamp, under `~/results/chisel`. Run `summarize_chisel.py` to generate `summary.csv`.

   ```bash
   cd ~/cdd/results/software_debloating/20230912230625/
   python ~/cdd/script/summarize_software_debloating.py .
   ```
   
##### Evaluate ddmin, ProbDD and CDD on BM-XML.

   Similarly, 
   
   ```bash
   cd /home/coq/cdd

   # ddmin (around 12 hours given single process)
   ./scripts/run_xml_reduction.sh --args_for_picireny "--dd ddmin --init-probability 0.0025"

   # probdd (around 10 hours given single process)
   ./scripts/run_xml_reduction.sh --args_for_picireny "--dd probdd --init-probability 0.0025"

   # evaluate CDD (around 10 hours given single process)
   ./scripts/run_xml_reduction.sh --args_for_picireny "--dd cdd --init-probability 0.0025"
   
   ```

### Enable or disable the randomness


