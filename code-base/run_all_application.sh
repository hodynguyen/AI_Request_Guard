#!/bin/bash

set -e  # dừng nếu có lỗi

echo "[STEP 0] Create Python virtual environment..."
if [ ! -d "venv" ]; then
  echo "Creating Python virtual environment..."
  python3 -m venv venv
fi
source venv/bin/activate

echo "[STEP 0.1] Install dependencies..."
pip install --upgrade pip
pip install -r ai-api/requirements.txt

echo "[STEP 1.1] Create dataset for training..."
cd ai-api/data

bash generate_params.sh
bash generate_endpoints.sh
bash generate_good_requests.sh
bash generate_attack_payloads.sh
bash generate_bad_requests.sh
bash generate_goodqueries_test.sh

cd ../
echo "[STEP 1.1] Length analysis..."
python 1_1_length_analysis.py

echo "[STEP 1.2] Padding + encript request..."
python 1_2_prepare_data.py

echo "[STEP 2.1] Training Autoencoder..."
python 2_1_train_autoencoder.py

echo "[STEP 2.2] Extract latent vector..."
python 2_2_extract_latent.py

echo "[STEP 2.3] Prepare data test..."
python 2_3_prepare_latent_test.py

echo "[STEP 2.4] Training OC-SVM..."
python 2_4_train_ocsvm.py

echo "[STEP 3.1] Evaluate OC-SVM..."
python 3_1_evaluate_ocsvm_latent.py

echo "[STEP 4] Boost system by Docker Compose..."
cd ../
docker compose down
docker compose up -d

echo "DONE! Open Kibana at: http://localhost:5601"
