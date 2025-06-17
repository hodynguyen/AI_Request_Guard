
import numpy as np
from sklearn.metrics import classification_report, confusion_matrix
import joblib

model = joblib.load("ocsvm_model.joblib")

X_test = np.load("latent_vectors_test.npy")
y_true = np.load("labels_test.npy")

y_pred = model.predict(X_test)

print("📊 Confusion Matrix:")
print(confusion_matrix(y_true, y_pred, labels=[1, -1]))

print("\n🧪 Classification Report:")
print(classification_report(y_true, y_pred, labels=[1, -1], target_names=["Normal", "Anomalous"]))
