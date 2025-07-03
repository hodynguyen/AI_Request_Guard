import torch  # Import PyTorch library
import torch.nn as nn  # Import neural network modules
from torch.utils.data import DataLoader, TensorDataset  # Import data loader and dataset utilities
import numpy as np  # Import NumPy for data processing
import json  # Import JSON to load vocabulary

# Load vocab size
with open("char2idx.json") as f:  # Open the character-to-index mapping
    char2idx = json.load(f)  # Load it as a dictionary
vocab_size = len(char2idx)  # Get vocabulary size

# Hyperparams
emb_dim = 64  # Size of each character embedding vector
hidden_dim = 32  # Size of hidden state in LSTM
batch_size = 64  # Number of samples per training batch
epochs = 50  # Number of training iterations over the entire dataset

# Load and prepare data
X = torch.tensor(np.load("padded_requests.npy"), dtype=torch.long)  # Load padded input requests as tensor
loader = DataLoader(TensorDataset(X, X), batch_size=batch_size, shuffle=True)  # Create batch loader (input = target for autoencoder)

# Model
class LSTMAutoencoder(nn.Module):  # Define LSTM Autoencoder class
    def __init__(self, vocab_size, emb_dim, hidden_dim):  # Initialize model with vocab, embedding, hidden size
        super().__init__()  # Call superclass constructor
        self.embedding = nn.Embedding(vocab_size + 1, emb_dim, padding_idx=0)  # Embedding layer for characters
        self.encoder = nn.LSTM(emb_dim, hidden_dim, batch_first=True)  # LSTM encoder
        self.decoder = nn.LSTM(hidden_dim, emb_dim, batch_first=True)  # LSTM decoder
        self.output = nn.Linear(emb_dim, vocab_size + 1)  # Linear layer to predict character indices

    def forward(self, x):  # Define forward pass
        x = self.embedding(x)  # Convert input indices to embeddings
        _, (h, _) = self.encoder(x)  # Encode the sequence to get hidden state h
        dec_input = h.repeat(x.size(1), 1, 1).transpose(0, 1)  # Repeat h to match sequence length as decoder input
        dec_output, _ = self.decoder(dec_input)  # Decode from h
        return self.output(dec_output)  # Predict character distribution for each timestep

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")  # Use GPU if available, else CPU
model = LSTMAutoencoder(vocab_size, emb_dim, hidden_dim).to(device)  # Create model and move it to device
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)  # Adam optimizer for training
criterion = nn.CrossEntropyLoss(ignore_index=0)  # Loss function, ignores padding index 0

# Training loop
for epoch in range(epochs):  # Repeat for each epoch
    total_loss = 0  # Track loss in current epoch
    for xb, yb in loader:  # Iterate over each batch
        xb, yb = xb.to(device), yb.to(device)  # Move data to device
        out = model(xb)  # Get model output
        loss = criterion(out.view(-1, out.size(-1)), yb.view(-1))  # Compute cross-entropy loss
        optimizer.zero_grad()  # Reset gradients
        loss.backward()  # Backpropagate error
        optimizer.step()  # Update weights
        total_loss += loss.item()  # Accumulate loss
    print(f"Epoch {epoch+1}, Loss: {total_loss:.4f}")  # Print loss after each epoch

# Save model
torch.save(model.state_dict(), "autoencoder.pt")  # Save model parameters to file
