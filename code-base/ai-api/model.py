import torch
import torch.nn as nn
import numpy as np
import joblib
import json

with open("char2idx.json") as f:
    char2idx = json.load(f)

max_len = 333 

class Encoder(nn.Module):
    def __init__(self, vocab_size, emb_dim=64, hidden_dim=32):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size + 1, emb_dim, padding_idx=0)
        self.encoder = nn.LSTM(emb_dim, hidden_dim, batch_first=True)

    def forward(self, x):
        x = self.embedding(x)
        _, (h, _) = self.encoder(x)
        return h.squeeze(0)

encoder = Encoder(vocab_size=len(char2idx))
encoder.load_state_dict(torch.load("autoencoder.pt"), strict=False)
encoder.eval()

ocsvm = joblib.load("ocsvm_model.joblib")

def encode_text(text):
    seq = [char2idx.get(c, 0) for c in text]
    seq = seq + [0] * (max_len - len(seq))
    input_tensor = torch.tensor([seq])
    with torch.no_grad():
        latent = encoder(input_tensor).numpy()
    return latent

def is_malicious(path: str, args: dict) -> bool:
    request_text = path + " " + str(args)
    z = encode_text(request_text)
    prediction = ocsvm.predict(z)
    return prediction[0] == -1
