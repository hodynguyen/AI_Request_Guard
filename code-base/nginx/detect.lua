local cjson = require "cjson"
local http = require "resty.http"

ngx.req.read_body()
local method = ngx.req.get_method()
local uri = ngx.var.request_uri
local args = ngx.req.get_uri_args()

local req_data = {
  method = method,
  path = uri,
  args = args
}

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

local ok, result = pcall(cjson.decode, res.body)
if not ok then
  ngx.status = 500
  ngx.say("Failed to decode AI response: ", res.body)
  return ngx.exit(500)
end

local function contains_attack_pattern(str)
  local patterns = {
    "UNION[%s_]+SELECT", -- SQLi
    "' OR", "--", "1=1", "sleep%(", -- SQLi
    "<script>", "onerror=", "svg/onload=", -- XSS
    "%.%.%/", -- Path Traversal
    "169%.254%.169%.254", "file://", "http://localhost", -- SSRF
  }

  for _, pattern in ipairs(patterns) do
    if string.find(string.lower(str), string.lower(pattern)) then
      return true
    end
  end
  return false
end

local function is_fake_block()
  if contains_attack_pattern(req_data.path) then return true end
  for k, v in pairs(req_data.args) do
    if contains_attack_pattern(k) or contains_attack_pattern(v) then
      return true
    end
  end
  return false
end

local log_data = {
  timestamp = ngx.now(),
  ip = ngx.var.remote_addr,
  method = method,
  uri = uri,
  args = args,
  result = result.decision
}

local function log_to_elasticsearch(data)
  local httpc = http.new()
  local es_res, es_err = httpc:request_uri("http://elasticsearch:9200/requests/_doc", {
    method = "POST",
    body = cjson.encode(data),
    headers = { ["Content-Type"] = "application/json" },
    keepalive_timeout = 60
  })
  if not es_res then
    ngx.log(ngx.ERR, "❌ Failed to log to Elasticsearch: ", es_err)
  end
end

if string.find(req_data.path, "admin") then
  log_data.result = "block_manual"
  log_to_elasticsearch(log_data)
  ngx.status = 403
  ngx.say("❌ Blocked manually (contains 'admin')")
  return ngx.exit(403)
end

if is_fake_block() then
  log_data.result = "block"
  log_to_elasticsearch(log_data)
  ngx.status = 403
  ngx.say("❌ Blocked by AI decision (simulated rule)")
  return ngx.exit(403)
end

log_to_elasticsearch(log_data)
ngx.say("✅ Request allowed.")
