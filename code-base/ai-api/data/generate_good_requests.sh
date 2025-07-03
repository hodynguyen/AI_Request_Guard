#!/bin/bash

METHOD_FILE="methods.txt"
ENDPOINT_FILE="endpoints.txt"
PARAM_FILE="params.txt"
OUT_FILE="goodqueries.txt"

echo -e "GET\nPOST" > "$METHOD_FILE"

for f in "$METHOD_FILE" "$ENDPOINT_FILE" "$PARAM_FILE"; do
  [[ ! -f $f ]] && echo "❌ Missing file: $f" && exit 1
done

mapfile -t methods < "$METHOD_FILE"
mapfile -t endpoints < "$ENDPOINT_FILE"
mapfile -t params < "$PARAM_FILE"

> "$OUT_FILE"

for i in {1..100000}; do
  method=${methods[$RANDOM % ${#methods[@]}]}
  endpoint=${endpoints[$RANDOM % ${#endpoints[@]}]}

  param_count=$((RANDOM % 4 + 1))
  query=""
  for ((j=0; j<param_count; j++)); do
    param=${params[$RANDOM % ${#params[@]}]}
    [[ -n "$query" ]] && query="$query&"
    query="$query$param"
  done

  if [[ "$method" == "GET" ]]; then
    echo "$method $endpoint?$query" >> "$OUT_FILE"
  else
    echo "$method $endpoint [$query]" >> "$OUT_FILE"
  fi
done

echo "✅ Generated 100000 good requests → $OUT_FILE"
