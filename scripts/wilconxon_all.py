import pandas as pd
from scipy.stats import wilcoxon
import numpy as np

# Function to convert column letter to index
def col_letter_to_index(letter):
    return ord(letter.lower()) - ord('a')

# Load the data from the CSV file
file_path = "data.csv"  # Replace with the actual path to your CSV file
data = pd.read_csv(file_path, header=None)  # Use header=None if the file has no header row

# Define column letters
columns = {
    "size_ddmin": "e",
    "size_probdd": "f",
    "size_cdd": "g",
    "time_ddmin": "h",
    "time_probdd": "i",
    "time_cdd": "j",
    "query_ddmin": "k",
    "query_probdd": "l",
    "query_cdd": "m"
}

# Convert column letters to indices
for key in columns:
    columns[key] = col_letter_to_index(columns[key])

# Function to clean and convert data to numerical values
def clean_and_convert(series):
    return pd.to_numeric(series, errors='coerce').dropna().values

# Function to perform Wilcoxon test
def perform_wilcoxon_test(data1, data2, metric_name, algo1, algo2):
    # Ensure both datasets have the same length
    min_length = min(len(data1), len(data2))
    data1, data2 = data1[:min_length], data2[:min_length]
    stat, p = wilcoxon(data1, data2)
    print(f"Wilcoxon Signed-Rank Test for {metric_name} ({algo1} vs {algo2}):")
    print(f"Statistic: {stat}, p-value: {p}")
    print()

# Define benchmark ranges
benchmark_ranges = {
    "c": (161, 180),
    "debloat": (181, 190),
    "xml": (191, 236)
}

# Function to process data for a specific benchmark range
def process_benchmark(data, start, end, columns, benchmark_name):
    print(f"\nWilcoxon Signed-Rank Test for Benchmark Suite: {benchmark_name}")

    size_ddmin = clean_and_convert(data.iloc[start:end + 1, columns["size_ddmin"]])
    size_probdd = clean_and_convert(data.iloc[start:end + 1, columns["size_probdd"]])
    size_cdd = clean_and_convert(data.iloc[start:end + 1, columns["size_cdd"]])

    time_ddmin = clean_and_convert(data.iloc[start:end + 1, columns["time_ddmin"]])
    time_probdd = clean_and_convert(data.iloc[start:end + 1, columns["time_probdd"]])
    time_cdd = clean_and_convert(data.iloc[start:end + 1, columns["time_cdd"]])

    query_ddmin = clean_and_convert(data.iloc[start:end + 1, columns["query_ddmin"]])
    query_probdd = clean_and_convert(data.iloc[start:end + 1, columns["query_probdd"]])
    query_cdd = clean_and_convert(data.iloc[start:end + 1, columns["query_cdd"]])

    metrics = [
        ("Size", size_ddmin, size_probdd, size_cdd),
        ("Time", time_ddmin, time_probdd, time_cdd),
        ("Query", query_ddmin, query_probdd, query_cdd),
    ]

    for metric_name, ddmin_data, probdd_data, cdd_data in metrics:
        perform_wilcoxon_test(ddmin_data, probdd_data, metric_name, "ddmin", "probdd")
        perform_wilcoxon_test(ddmin_data, cdd_data, metric_name, "ddmin", "cdd")
        perform_wilcoxon_test(probdd_data, cdd_data, metric_name, "probdd", "cdd")

# Process total data
print("\nWilcoxon Signed-Rank Test for Total Data:")
total_start, total_end = 161, 236
process_benchmark(data, total_start, total_end, columns, "Total")
