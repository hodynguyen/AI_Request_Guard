#!/bin/bash

set -e  # dừng nếu có lỗi

echo "🚀 [STEP 0] Create Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "📦 [STEP 0.1] Install dependencies..."
pip install --upgrade pip
pip install -r ai-api/requirements.txt

echo "📂 [STEP 1.1] Extract data from CSIC CSV..."
python ai-api/1_2_extract_csic_data.py

echo "📂 [STEP 1.2] Padding + encript request..."
python ai-api/1_2_prepare_data.py

echo "🎯 [STEP 2.1] Training Autoencoder..."
python ai-api/2_1_train_autoencoder.py

echo "🔎 [STEP 2.2] Extract latent vector..."
python ai-api/2_2_extract_latent.py

echo "🧠 [STEP 2.3] Training OC-SVM..."
python ai-api/2_3_train_ocsvm.py

echo "🧪 [STEP 3.1] Prepare data test..."
python ai-api/3_1_prepare_latent_test.py

echo "📊 [STEP 3.2] Evaluate OC-SVM..."
python ai-api/3_2_evaluate_ocsvm_latent.py

echo "🐳 [STEP 4] Boost system by Docker Compose..."
docker compose down
docker compose up -d

echo "✅ DONE! Open Kibana at: http://localhost:5601"
