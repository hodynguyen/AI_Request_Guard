#!/bin/bash

ENDPOINT_FILE="endpoints.txt"
> "$ENDPOINT_FILE"

declare -A domains
domains=(
  [ecommerce]="product cart checkout order payment user auth coupon wishlist review"
  [erp]="invoice employee payroll attendance leave report asset department audit workflow"
  [logistics]="shipment tracking warehouse delivery route fleet driver dispatch package eta"
  [learning]="course lesson student teacher quiz assignment grade certificate exam module"
  [social]="user post comment like follow message friend share notification profile"
  [entertainment]="movie tv show actor rating review genre ticket episode trailer"
  [music]="track album artist playlist listen favorite genre radio mix recommend"
  [static]="assets cdn static public media images js css fonts lib"
)

actions=(list get create update delete search upload download share export)
file_extensions=(.jpg .png .webp .gif .css .js .svg .woff .ttf .html .jsp .php)

generate_endpoint() {
  local domain=$1
  local resource=$2
  local action=${actions[$RANDOM % ${#actions[@]}]}
  local id=$((RANDOM % 10000 + 1))

  if [[ "$domain" == "static" ]]; then
    file="$resource/$id${file_extensions[$RANDOM % ${#file_extensions[@]}]}"
    [[ $((RANDOM % 3)) -eq 0 ]] && echo "/cdn/cache/$file" || echo "/$file"
  else
    case $((RANDOM % 6)) in
      0) echo "/api/$domain/$resource";;
      1) echo "/api/$domain/$resource/$id";;
      2) echo "/api/$domain/$resource/$action";;
      3) echo "/api/$domain/$resource/$id/$action";;
      4) echo "/$domain/$resource/$action";;
      5) echo "/$domain/$resource/$id";;
    esac
  fi
}

count=0
total=10000
while [ $count -lt $total ]; do
  for domain in "${!domains[@]}"; do
    IFS=' ' read -r -a resources <<< "${domains[$domain]}"
    resource=${resources[$RANDOM % ${#resources[@]}]}
    ep=$(generate_endpoint "$domain" "$resource")
    echo "$ep" >> "$ENDPOINT_FILE"
    count=$((count + 1))
    [[ $count -ge $total ]] && break
  done
done

echo "✅ Generated $count endpoints → $ENDPOINT_FILE"
