import json
import numpy as np
import os

INPUT_FILE = "data/goodqueries.txt"
OUTPUT_NPY = "padded_requests.npy"
OUTPUT_DICT = "char2idx.json"

if not os.path.exists(INPUT_FILE):
    raise FileNotFoundError(f"File '{INPUT_FILE}' not found!")

with open(INPUT_FILE, "r", encoding="utf-8") as f:
    lines = [line.strip() for line in f if line.strip()]

if not lines:
    raise ValueError("Input file is empty.")

tokenized = [list(line) for line in lines]
chars = sorted(set(c for line in tokenized for c in line))
char2idx = {c: i + 1 for i, c in enumerate(chars)} 

encoded = [[char2idx[c] for c in line] for line in tokenized]
max_len = max(len(seq) for seq in encoded)
padded = [seq + [0] * (max_len - len(seq)) for seq in encoded]

np.save(OUTPUT_NPY, np.array(padded, dtype=np.int32))
with open(OUTPUT_DICT, "w", encoding="utf-8") as f:
    json.dump(char2idx, f, ensure_ascii=False, indent=2)

print(f"✅ Saved {len(padded)} samples")
print(f"ℹ️ Max length: {max_len}, Vocab size: {len(char2idx)}")
