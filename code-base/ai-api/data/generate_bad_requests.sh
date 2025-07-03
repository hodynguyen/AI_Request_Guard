#!/bin/bash

# Input files
PAYLOAD_FILE="attack_payloads.txt"
ENDPOINT_FILE="endpoints.txt"
PARAM_FILE="params.txt"
METHOD_FILE="methods.txt"
OUTPUT_FILE="badqueries.txt"

> "$OUTPUT_FILE"

# Read files into arrays
mapfile -t PAYLOADS < "$PAYLOAD_FILE"
mapfile -t ENDPOINTS < "$ENDPOINT_FILE"
mapfile -t PARAMS < "$PARAM_FILE"
mapfile -t METHODS < "$METHOD_FILE"

TOTAL=50000

for ((i=0; i<TOTAL; i++)); do
  payload="${PAYLOADS[RANDOM % ${#PAYLOADS[@]}]}"
  method="${METHODS[RANDOM % ${#METHODS[@]}]}"
  endpoint="${ENDPOINTS[RANDOM % ${#ENDPOINTS[@]}]}"
  param="${PARAMS[RANDOM % ${#PARAMS[@]}]}"

  # Sinh thêm ID để đa dạng URL
  id=$((RANDOM % 10000))
  if [[ "$payload" == *"="* ]]; then
    full_endpoint="${endpoint}?${param}=${payload}"
  else
    full_endpoint="${endpoint}?id=${id}&${param}=${payload}"
  fi

  echo "$method $full_endpoint" >> "$OUTPUT_FILE"
done

echo "✅ Generated $TOTAL bad queries → $OUTPUT_FILE"
