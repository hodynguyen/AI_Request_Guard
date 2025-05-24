import joblib
import numpy as np

# Load model khi khởi động
model = joblib.load("svm_model.joblib")

# Từ khóa đáng ngờ
block_keywords = ["select", "drop", "union", "<script>", "--"]

# Hàm trích xuất đặc trưng từ request
def extract_features(path: str, args: dict):
    full_text = path.lower() + " " + str(args).lower()
    length = len(full_text)
    suspicious_count = sum(kw in full_text for kw in block_keywords)
    return np.array([[length, suspicious_count]])

# Gọi mô hình để phân loại
def is_malicious(path: str, args: dict) -> bool:
    features = extract_features(path, args)
    print("Feature:", features)  # 👈 In ra để biết input đang gửi là gì
    prediction = model.predict(features)
    print("Prediction:", prediction)
    return prediction[0] == -1

