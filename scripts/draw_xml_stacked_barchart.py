import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import matplotlib

plt.rcParams['font.family'] = 'Times New Roman'
plt.rcParams['pdf.fonttype'] = 42
fontsize = 14
tick_label_size = 25
plt.rcParams.update({'font.size': fontsize})
matplotlib.rcParams['pdf.fonttype'] = 42
matplotlib.rcParams['ps.fonttype'] = 42

# Corrected data from the initial request
other_total = 12407
complement_total = 13928
repeated_total = 2991
probdd_total = 17775
cdd_total = 18653

text_size = 20

categories = ['ddmin', 'ProbDD', 'CDD']

colors = {
    'Other': 'skyblue',
    'Complement': 'lightgreen',
    'Revisit': 'salmon',
    'ProbDD': 'lightgrey',
    'CDD': 'darkgrey'
}

data_corrected = {
    'Other': [other_total, 0, 0],
    'Complement': [complement_total, 0, 0],
    'Revisit': [repeated_total, 0, 0],
    'ProbDD': [0, probdd_total, 0],  # Correctly identifying ProbDD as a separate category
    'CDD': [0, 0, cdd_total]      # Correctly identifying CDD as a separate category
}

# Success counts for each category in the order specified in data_corrected
other_success = 1485
complement_success = 830
repeated_success = 2
probdd_success = 2176
cdd_success = 2258

# Calculate success rates and format them into strings
other_success_rate = f"{other_success:,} / {other_total:,} \n≈ {other_success/other_total:.2%}"
complement_success_rate = f"{complement_success:,} / {complement_total:,} \n≈ {complement_success/complement_total:.2%}"
repeated_success_rate = f"{repeated_success:,} / {repeated_total:,} \n≈ {repeated_success/repeated_total:.2%}"
probdd_success_rate = f"{probdd_success:,} / {probdd_total:,} \n≈ {probdd_success/probdd_total:.2%}"
cdd_success_rate = f"{cdd_success:,} / {cdd_total:,} \n≈ {cdd_success/cdd_total:.2%}"

success_rates = [other_success_rate, complement_success_rate, repeated_success_rate, probdd_success_rate, cdd_success_rate]
# Preparing the plot for a corrected stacked bar chart with annotations
fig, ax = plt.subplots(figsize=(5, 3.8))

# We need to keep track of the bottom for the 'ddmin' stacks
bottoms = [0, 0, 0]

index = 0  # To iterate through success rates for annotations
for category, values in data_corrected.items():
    if category in ['ProbDD', 'CDD']:  # Directly plot ProbDD and CDD without stacking
        ax.bar(categories[1:], values[1:], label=category, color=colors[category])
        for i, value in enumerate(values[1:]):
            if value > 0:  # Only add text if there is a value to report
                ax.text(i+1, value / 2, success_rates[index], ha='center', va='center', color='black', )
        index += 1
    else:  # Stack 'ddmin' categories
        ax.bar(categories[0], values[0], bottom=bottoms[0], label=category, color=colors[category])
        text_pos = bottoms[0] + values[0] / 2  # Calculate the position for the annotation
        ax.text(0, text_pos, success_rates[index], ha='center', va='center', color='black')
        bottoms[0] += values[0]  # Update the bottom for the next stack
        index += 1

ax.set_ylabel('Query Number (thousand)')
# ax.set_title('Query Distribution of ddmin, compared to ProbDD and CDD')
ax.yaxis.set_major_formatter(ticker.FuncFormatter(lambda x, pos: f'{int(x/1000)}'))
ax.legend()

plt.subplots_adjust(left=0.12, right=0.98, top=0.99, bottom=0.07)
# plt.tight_layout()
# Saving the adjusted plot as a PDF file
plt.savefig('./xml_stacked_barchart.pdf')
