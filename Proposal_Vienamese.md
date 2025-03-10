# AI-Request-Guard: Hệ thống phát hiện request HTTP/HTTPS bất thường

## 1. Giới thiệu
- Các hệ thống web hiện đại phải đối mặt với nhiều cuộc tấn công như **SQL Injection (SQLi), Cross-Site Scripting (XSS), Server-Side Request Forgery (SSRF), và DDoS**.
- Các phương pháp bảo mật truyền thống **dựa vào danh sách mẫu (signature-based)**, không hiệu quả với các cuộc tấn công **zero-day**.
- Đề án này ứng dụng **AI và NLP** để phát hiện request nguy hiểm theo **ngữ cảnh**, tích hợp **Explainable AI (XAI) để giải thích quyết định**, và sử dụng **Unlearning để tự động cập nhật mô hình**.

---

## 2. Mục tiêu
1. **Phát hiện request HTTP/HTTPS bất thường** (SQLi, XSS, SSRF, DDoS).
2. **Nhận diện tấn công chưa biết (Zero-Day Attack Detection)** bằng **One-Class Classification & Self-Supervised Learning**.
3. **Explainable AI (XAI)** giúp giải thích lý do request bị chặn.
4. **Unlearning để quên dữ liệu lỗi thời**, tránh mô hình bị bias.
5. **Tích hợp dễ dàng** với **Nginx, API Gateway, Kubernetes, SIEM** mà không ảnh hưởng hiệu suất.

---

## 3. Kiến trúc hệ thống
### 🔹 **Luồng xử lý request**
1. **Client gửi request HTTP/HTTPS**.
2. **Nginx + LuaJIT** kiểm tra request ban đầu.
3. **LuaJIT forward request đáng ngờ** đến AI API (FastAPI).
4. **Mô hình AI (BERT/LSTM) phân loại request**:
   - ✅ **Hợp lệ** → Forward đến backend.
   - ❌ **Bất thường** → Chặn & ghi log.
5. **Logging & monitoring (Elasticsearch, Kibana, Grafana)** theo dõi thời gian thực.

### 🔹 **Công nghệ triển khai**
- **Layer 1: Proxy Filtering** → Nginx + LuaJIT.
- **Layer 2: AI-based Detection** → FastAPI + Transformer Model.
- **Layer 3: Logging & Monitoring** → Elasticsearch, Kibana, Grafana.
- **Layer 4: Continuous Learning** → Unlearning + Active Learning.

---

## 4. Công nghệ sử dụng
| Thành phần | Công nghệ |
|------------|------------|
| Proxy Filtering | Nginx + LuaJIT |
| AI Model | Transformer (BERT/LSTM) + One-Class Classification |
| API Backend | FastAPI (Python) |
| Logging | Elasticsearch, Kibana, Grafana |
| Deployment | Docker, Kubernetes |
| Continuous Learning | Unlearning + Active Learning |

---

## 5. Ứng dụng thực tế
✔ **Tích hợp linh hoạt**:  
   - **Web Server (Apache, Nginx)**.  
   - **API Gateway (Kong, Traefik)**.  
   - **Kubernetes, Cloud Platforms**.  

✔ **Phát hiện tấn công Zero-Day không cần signature**.

✔ **Explainable AI (XAI) giúp tăng cường bảo mật**.

✔ **Unlearning đảm bảo mô hình luôn cập nhật**.

---

🚀 **Bảo vệ hệ thống web với AI-Request-Guard!**
