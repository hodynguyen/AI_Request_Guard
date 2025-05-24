local cjson = require "cjson"
local http = require "resty.http"

-- Đọc thông tin request
ngx.req.read_body()
local method = ngx.req.get_method()
local uri = ngx.var.request_uri
local args = ngx.req.get_uri_args()

local req_data = {
  method = method,
  path = uri,
  args = args
}

-- Gửi dữ liệu tới AI API (mock hiện tại)
local httpc = http.new()
local res, err = httpc:request_uri("http://ai-api:8000/predict", {
  method = "POST",
  body = cjson.encode(req_data),
  headers = {["Content-Type"] = "application/json"},
  keepalive_timeout = 60
})

if not res then
  ngx.status = 500
  ngx.say("Failed to request AI API: ", err)
  return ngx.exit(500)
end

-- Decode JSON an toàn
local ok, result = pcall(cjson.decode, res.body)
if not ok then
  ngx.status = 500
  ngx.say("Failed to decode AI response: ", res.body)
  return ngx.exit(500)
end

-- 🚫 Chặn nếu URL chứa "admin"
if string.find(req_data.path, "admin") then
  ngx.status = 403
  ngx.say("❌ Blocked manually (contains 'admin')")
  return ngx.exit(403)
end

-- 🚫 Chặn nếu AI trả về block
if result.decision == "block" then
  ngx.status = 403
  ngx.say("❌ Blocked by AI decision")
  return ngx.exit(403)
end

-- ✅ Cho phép các request còn lại
ngx.say("✅ Request allowed.")
