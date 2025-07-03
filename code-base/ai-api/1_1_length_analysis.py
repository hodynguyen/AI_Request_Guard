import matplotlib.pyplot as plt
import numpy as np
import json

# Read data from files
with open("data/goodqueries.txt", "r", encoding="utf-8") as f:
    good_lines = [line.strip() for line in f if line.strip()]

with open("data/badqueries.txt", "r", encoding="utf-8") as f:
    bad_lines = [line.strip() for line in f if line.strip()]

# Compute the lengths of each request
good_lengths = [len(line) for line in good_lines]
bad_lengths = [len(line) for line in bad_lines]

# Determine max length so that 99% of requests are shorter or equal
combined_lengths = np.array(good_lengths + bad_lengths)
max_len_99 = int(np.percentile(combined_lengths, 99))
with open("config.json", "w") as f:
    json.dump({"max_len": max_len_99}, f)

# Plot histogram
plt.figure(figsize=(10, 5))
plt.hist(good_lengths, bins=50, alpha=0.6, label='Good Requests', color='green', edgecolor='black')
plt.hist(bad_lengths, bins=50, alpha=0.6, label='Bad Requests', color='red', edgecolor='black')
plt.axvline(max_len_99, color='blue', linestyle='--', label=f"99% Max Length = {max_len_99}")
plt.title("Distribution of Request Lengths (Good vs Bad)")
plt.xlabel("Request Length (in characters)")
plt.ylabel("Number of Requests")
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("length_distribution.png")
