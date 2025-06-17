import torch
import torch.nn as nn
from torch.utils.data import DataLoader
import numpy as np
import json

with open("char2idx.json") as f:
    char2idx = json.load(f)
vocab_size = len(char2idx)

class Encoder(nn.Module):
    def __init__(self, vocab_size, emb_dim, hidden_dim):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size + 1, emb_dim, padding_idx=0)
        self.encoder = nn.LSTM(emb_dim, hidden_dim, batch_first=True)

    def forward(self, x):
        x = self.embedding(x)
        _, (h, _) = self.encoder(x)
        return h.squeeze(0)

X = torch.tensor(np.load("padded_requests.npy"), dtype=torch.long)
loader = DataLoader(X, batch_size=64)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
encoder = Encoder(vocab_size=vocab_size, emb_dim=64, hidden_dim=32).to(device)
encoder.load_state_dict(torch.load("autoencoder.pt", map_location=device), strict=False)
encoder.eval()

latents = []
with torch.no_grad():
    for xb in loader:
        xb = xb.to(device)
        z = encoder(xb)
        latents.append(z.cpu().numpy())

Z = np.concatenate(latents, axis=0)
np.save("latent_vectors.npy", Z)
print(f"✅ Saved {Z.shape[0]} latent vectors, dim = {Z.shape[1]}")
