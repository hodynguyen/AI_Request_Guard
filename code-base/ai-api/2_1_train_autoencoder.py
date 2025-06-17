import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset
import numpy as np
import json

# Load vocab size
with open("char2idx.json") as f:
    char2idx = json.load(f)
vocab_size = len(char2idx)

# Hyperparams
emb_dim = 64
hidden_dim = 32
batch_size = 64
epochs = 10

# Load and prepare data
X = torch.tensor(np.load("padded_requests.npy"), dtype=torch.long)
loader = DataLoader(TensorDataset(X, X), batch_size=batch_size, shuffle=True)

# Model
class LSTMAutoencoder(nn.Module):
    def __init__(self, vocab_size, emb_dim, hidden_dim):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size + 1, emb_dim, padding_idx=0)
        self.encoder = nn.LSTM(emb_dim, hidden_dim, batch_first=True)
        self.decoder = nn.LSTM(hidden_dim, emb_dim, batch_first=True)
        self.output = nn.Linear(emb_dim, vocab_size + 1)

    def forward(self, x):
        x = self.embedding(x)
        _, (h, _) = self.encoder(x)
        dec_input = h.repeat(x.size(1), 1, 1).transpose(0, 1)
        dec_output, _ = self.decoder(dec_input)
        return self.output(dec_output)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = LSTMAutoencoder(vocab_size, emb_dim, hidden_dim).to(device)
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
criterion = nn.CrossEntropyLoss(ignore_index=0)

# Training loop
for epoch in range(epochs):
    total_loss = 0
    for xb, yb in loader:
        xb, yb = xb.to(device), yb.to(device)
        out = model(xb)
        loss = criterion(out.view(-1, out.size(-1)), yb.view(-1))
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        total_loss += loss.item()
    print(f"Epoch {epoch+1}, Loss: {total_loss:.4f}")

# Save model
torch.save(model.state_dict(), "autoencoder.pt")
