import numpy as np
from sklearn.svm import OneClassSVM
import joblib

X_train = np.load("latent_vectors.npy")

model = OneClassSVM(kernel="rbf", gamma=0.001, nu=0.05)
model.fit(X_train)

joblib.dump(model, "ocsvm_model.joblib")

print(f"✅ OC-SVM model trained and saved (samples: {X_train.shape[0]}, dim: {X_train.shape[1]})")
