Thank all reviewers for your valuable feedback and for taking the time to review our artifact. Your suggestions have helped us improve the clarity and usability of our submission.

### Response to Reviewer B:
We appreciate your feedback regarding the organization of the artifact. To address your suggestion, we have added a **Project Structure** section to the documentation, providing a clear overview of the repository layout, including source code, benchmarks, tools, and scripts. This should help users navigate the artifact more efficiently. 

Additionally, we have introduced a **Paper Overview** section that outlines how the experiments relate to the key findings in the paper. This provides better alignment between the artifact and the research contributions, making it clearer how each component supports the findings.

### Response to Reviewer C:
We acknowledge that randomness and long runtime are inherent challenges in our experiments. While these factors cannot be entirely avoided, we have taken steps to ensure reproducibility as much as possible. Specifically:

- We have included precomputed datasets (e.g., ./scripts/data.csv) to allow users to analyze results without needing to rerun all experiments from scratch.

- We provide the necessary scripts for reproducing Figure 2 (e.g., ./scripts/draw\_c\_stacked\_barchart.py), which is a key component of the paper's analysis.

These additions should help mitigate the effects of randomness and long execution times while still allowing for a thorough evaluation of the artifact.

### Updated Version
The updated version of the artifact is now available at https://zenodo.org/records/14854239 (Version v3).
