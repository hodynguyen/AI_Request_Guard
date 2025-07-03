#!/bin/bash

PARAM_FILE="params.txt"
> "$PARAM_FILE"

keys=(
  id product_id user_id order_id course_id token session_id
  email username password q search filter sort lang currency
  lat lon zip location region time date timestamp version
  page limit offset mode theme mobile os platform device
  genre rating price discount available status role ref code
  event campaign promo source utm_source utm_campaign redirect
)
values=(
  admin john test demo guest root manager abc123 hello
  search+query example@gmail.com vietnam us dark light mobile desktop
  true false yes no 1 0 vn en laptop book 123 456 789 999
)

for i in {1..10000}; do
  key=${keys[$RANDOM % ${#keys[@]}]}
  value=${values[$RANDOM % ${#values[@]}]}
  echo "$key=$value" >> "$PARAM_FILE"
done

echo "✅ Generated 10000 random params → $PARAM_FILE"
