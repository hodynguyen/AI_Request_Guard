# AI-Request-Guard: Intelligent HTTP/HTTPS Anomaly Detection System

## 1. Introduction
- Modern web applications face various attacks such as **SQL Injection (SQLi), Cross-Site Scripting (XSS), Server-Side Request Forgery (SSRF), and DDoS**.
- Traditional security methods rely on **signature-based detection**, making them ineffective against **zero-day attacks**.
- This project leverages **AI and NLP** to detect malicious requests **contextually**, integrates **Explainable AI (XAI) for transparency**, and applies **Unlearning to dynamically update knowledge**.

---

## 2. Objectives
1. **Detect anomalous HTTP/HTTPS requests** (SQLi, XSS, SSRF, DDoS).
2. **Identify unknown attack types (Zero-Day Detection)** using **One-Class Classification & Self-Supervised Learning**.
3. **Utilize Explainable AI (XAI)** to provide reasoning behind blocked requests.
4. **Implement Unlearning** to forget outdated attack patterns and prevent bias.
5. **Seamless integration** with **Nginx, API Gateways, Kubernetes, and SIEM** without impacting system performance.

---

## 3. System Architecture
### 🔹 **Request Processing Flow**
1. **Client sends an HTTP/HTTPS request**.
2. **Nginx + LuaJIT proxy** intercepts and performs initial filtering.
3. **Lua script forwards suspicious requests** to the AI-based FastAPI service.
4. **Deep Learning Model (BERT/LSTM)** classifies requests:
   - ✅ **Legitimate request** → Forward to backend.
   - ❌ **Anomalous request** → Block & log.
5. **Logging & monitoring (Elasticsearch, Kibana, Grafana)** track real-time threat activities.

### 🔹 **Deployment Stack**
- **Layer 1: Proxy Filtering** → Nginx + LuaJIT.
- **Layer 2: AI-based Classification** → FastAPI + Transformer-based model.
- **Layer 3: Logging & Monitoring** → Elasticsearch, Kibana, Grafana.
- **Layer 4: Continuous Learning** → Unlearning + Active Learning.

---

## 4. Implementation Details
### 🔹 **Step 1: Nginx + LuaJIT Request Filtering**
- Lua script inspects request **headers, body, and IP**.
- Suspicious requests are forwarded to the AI-based API.

### 🔹 **Step 2: AI Model Deployment (FastAPI + PyTorch)**
- Transformer-based model (BERT/LSTM) encodes requests.
- **One-Class SVM, Autoencoder, or Isolation Forest** detects novel attack types.

### 🔹 **Step 3: Explainable AI (XAI)**
- Uses **SHAP, LIME** to highlight suspicious request elements.
- Provides a **visual dashboard** for administrators.

### 🔹 **Step 4: Logging & Monitoring**
- Stores all requests in **Elasticsearch** for real-time analysis.
- **Kibana/Grafana dashboards** visualize threat patterns.

### 🔹 **Step 5: Continuous Model Updating with Unlearning**
- **Removes outdated attack signatures** without retraining the entire model.
- **Active Learning**: Flags unclear requests for human validation.

---

## 5. Integration & Technology Stack
| Component | Technology |
|------------|------------|
| Proxy Filtering | Nginx + LuaJIT |
| AI Model | Transformer (BERT/LSTM) + One-Class Classification |
| API Backend | FastAPI (Python) |
| Logging | Elasticsearch, Kibana, Grafana |
| Deployment | Docker, Kubernetes |
| Continuous Learning | Unlearning + Active Learning |

---

## 6. Real-World Applications
✔ **Easily integrates** into:
   - **Web Servers** (Apache, Nginx).
   - **API Gateways** (Kong, Traefik).
   - **Cloud-Native environments** (Kubernetes, AWS, GCP).

✔ **Zero-Day Attack Detection** without relying on fixed attack signatures.

✔ **Explainable AI (XAI) for security transparency**.

✔ **Unlearning mechanism ensures long-term adaptability**.

---

## 7. Project Timeline
| Week | Task |
|------------|------------|
| 1-2 | Nginx + LuaJIT filtering setup |
| 3-4 | FastAPI + Transformer model deployment |
| 5-6 | AI Model fine-tuning with One-Class SVM & Autoencoder |
| 7-8 | Explainable AI (XAI) integration |
| 9-10 | Logging & monitoring setup |
| 11-12 | Continuous learning via Unlearning |
| 13-14 | Performance testing & optimizations |
| 15 | Final report & submission |

---

## 8. Conclusion
- This system **detects known and unknown web attacks** in real-time.
- **Explainable AI enhances security transparency**.
- **Unlearning enables continuous model evolution**.
- **Seamless deployment across diverse infrastructures**.

---

🚀 **AI-powered request filtering for a safer web!**
