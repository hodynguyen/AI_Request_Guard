import numpy as np
from sklearn.svm import OneClassSVM
import joblib

# Tạo dữ liệu hợp lệ: độ dài URL + số từ khóa
X_train = np.array([
    [15, 0],
    [18, 0],
    [25, 0],
    [30, 0],
    [22, 0],
])

# Huấn luyện
model = OneClassSVM(gamma='auto', nu=0.1)
model.fit(X_train)

# Lưu mô hình
joblib.dump(model, "svm_model.joblib")
