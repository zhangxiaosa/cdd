import os
import sys


def delete_non_xml_files(path):
    for root, _, files in os.walk(path):
        for file in files:
            if not file.endswith('.xml'):
                file_to_remove = os.path.join(root, file)
                os.remove(file_to_remove)


BENCHMARK_LIST = ['xml10', 'xml12', 'xml15', 'xml17', 'xml18', 'xml19', 'xml2', 'xml20', 'xml21', 'xml22', 'xml23',
                  'xml25', 'xml26', 'xml27', 'xml3', 'xml30', 'xml31', 'xml32', 'xml33', 'xml36', 'xml38', 'xml39',
                  'xml4', 'xml41', 'xml42', 'xml43', 'xml49', 'xml50', 'xml51', 'xml52', 'xml53', 'xml54', 'xml55',
                  'xml56', 'xml58', 'xml59', 'xml60', 'xml61', 'xml62', 'xml63', 'xml64', 'xml65', 'xml66', 'xml67',
                  'xml68', 'xml69', 'xml7', 'xml70', 'xml71', 'xml72', 'xml73', 'xml74', 'xml75', 'xml76', 'xml77',
                  'xml78', 'xml79', 'xml80', 'xml81', 'xml9']

RESULT_PATH = sys.argv[1]

for target in BENCHMARK_LIST:
    collect_path = os.path.join(RESULT_PATH, "result_" + target)
    if not os.path.exists(collect_path):
        print(f"{target} is not available")
        continue

    delete_non_xml_files(collect_path)
