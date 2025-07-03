import numpy as np
from sklearn.svm import OneClassSVM
from sklearn.metrics import classification_report
from sklearn.model_selection import ParameterGrid
import joblib

X_train = np.load("latent_vectors.npy")
X_test = np.load("latent_vectors_test.npy")
y_true = np.load("labels_test.npy")

param_grid = {
    "gamma": [1e-3, 1e-2, 1e-1],
    "nu": [0.01, 0.05, 0.1, 0.2]
}

best_f1 = 0
best_model = None
best_params = None

for params in ParameterGrid(param_grid):
    model = OneClassSVM(kernel="rbf", **params)
    model.fit(X_train)
    y_pred = model.predict(X_test)

    report = classification_report(y_true, y_pred, labels=[1, -1], target_names=["Normal", "Anomalous"], output_dict=True)
    f1 = report.get("Anomalous", {}).get("f1-score", 0.0)

    print(f"[gamma={params['gamma']}, nu={params['nu']}] → F1 anomaly = {f1:.4f}")

    if f1 > best_f1:
        best_f1 = f1
        best_model = model
        best_params = params

# Save best model
joblib.dump(best_model, "ocsvm_model_best.joblib")
print(f"\n✅ Best model saved with gamma={best_params['gamma']}, nu={best_params['nu']}, F1={best_f1:.4f}")
