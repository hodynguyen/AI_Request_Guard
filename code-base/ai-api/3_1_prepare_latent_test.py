# prepare_latent_test.py

import torch
import json
import numpy as np
from torch.utils.data import DataLoader
from torch import nn

with open("char2idx.json") as f:
    char2idx = json.load(f)

vocab_size = len(char2idx)
emb_dim = 64
hidden_dim = 32
max_len = 128  

def encode_request(request: str, max_len: int = 128):
    seq = [char2idx.get(c, 0) for c in request]
    return seq[:max_len] + [0] * max(0, max_len - len(seq))

class Encoder(nn.Module):
    def __init__(self, vocab_size, emb_dim, hidden_dim):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size + 1, emb_dim, padding_idx=0)
        self.encoder = nn.LSTM(emb_dim, hidden_dim, batch_first=True)

    def forward(self, x):
        x = self.embedding(x)
        _, (h, _) = self.encoder(x)
        return h.squeeze(0)

# === Load model ===
encoder = Encoder(vocab_size, emb_dim, hidden_dim)
encoder.load_state_dict(torch.load("autoencoder.pt"), strict=False)
encoder.eval()

good_requests = [line.strip() for line in open("data/goodqueries.txt") if line.strip()]
bad_requests = [line.strip() for line in open("data/badqueries.txt") if line.strip()]

all_requests = good_requests + bad_requests
encoded = [encode_request(req, max_len) for req in all_requests]
X = torch.tensor(encoded, dtype=torch.long)

# === Extract latent vectors ===
loader = DataLoader(X, batch_size=64)
latents = []

with torch.no_grad():
    for xb in loader:
        z = encoder(xb)
        latents.append(z.numpy())

Z = np.concatenate(latents, axis=0)

# === Save latent vectors và ground truth labels ===
np.save("latent_vectors_test.npy", Z)
np.save("labels_test.npy", np.array([1]*len(good_requests) + [-1]*len(bad_requests)))

print(f"✅ Saved latent_vectors_test.npy and labels_test.npy with {len(Z)} samples")
