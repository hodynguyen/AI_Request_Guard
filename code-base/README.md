# 🛡️ AI-Request-Guard: HTTP/HTTPS Anomaly Detection System

This project provides a complete pipeline to detect web request anomalies (such as SQLi, XSS, SSRF, etc.) using an LSTM Autoencoder + OC-SVM. The system integrates with Nginx, LuaJIT, FastAPI, and logs suspicious requests to Elasticsearch + Kibana for visualization.

---

## 📦 Requirements

Before running, make sure the following are installed:

- ✅ [Python 3.8+](https://www.python.org/)
- ✅ [Docker & Docker Compose](https://docs.docker.com/compose/)
- ✅ Internet connection (to download base images and Python packages)
- ✅ OS: Linux (tested on Ubuntu 20.04+)

---

## 🧰 Project Structure

```
code-base/
├── run_all_application.sh        # Master script to execute all steps
├── README.md                     # You are here
├── docker-compose.yml            # Docker setup for Nginx, FastAPI, Elasticsearch, Kibana
├── nginx/                        # Nginx + LuaJIT proxy layer
├── ai-api/
│   ├── 1_2_extract_csic_data.py
│   ├── 1_2_prepare_data.py
│   ├── 2_1_train_autoencoder.py
│   ├── 2_2_extract_latent.py
│   ├── 2_3_train_ocsvm.py
│   ├── 3_1_prepare_latent_test.py
│   ├── 3_2_evaluate_ocsvm_latent.py
│   ├── 4_model_serving/
│   │   ├── main.py
│   │   ├── model.py
│   │   └── requirements.txt
```

---

## 🚀 How to Run

Simply execute the master shell script below:

```bash
./run_all_application.sh
```

This script will automatically:

1. ✅ Create a Python virtual environment
2. 📥 Extract & preprocess the CSIC dataset
3. 🧠 Train an LSTM Autoencoder + OC-SVM
4. 🧪 Evaluate detection performance
5. 🐳 Deploy the detection API with Docker Compose
6. 📊 Enable real-time visualization in Kibana

---

## 🔍 After Deployment

- ✅ Access detection API: `http://localhost:8080`
- ✅ View request logs in Kibana: `http://localhost:5601`
- ✅ Elasticsearch service runs at: `http://localhost:9200`

Example test request:

```bash
curl "http://localhost:8080/?q=<script>alert(1)</script>"
```

---

## 🧠 AI Model Summary

- **Encoder**: LSTM-based autoencoder trained on normal requests.
- **Detector**: One-Class SVM trained on the encoder’s latent vectors.
- **Input**: Raw HTTP request paths and parameters.
- **Output**: `allow` or `block` decision + logs to Elasticsearch.

---

## 📌 Notes

- Training may take several minutes depending on your hardware.
- Kibana may need ~30 seconds to start fully.
- Make sure Docker is not blocked by firewall or proxy.

---

## 👨‍💻 Author

- **Nguyễn Thành Đạt** — 20205178 — HUST
