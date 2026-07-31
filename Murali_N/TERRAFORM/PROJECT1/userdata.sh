#!/bin/bash
set -euxo pipefail
yum update -y
yum install -y httpd
systemctl enable --now httpd

cat >/var/www/html/index.html <<HTML
<!doctype html>
<html>
  <head><title>Two-tier application webpage created by Murali N</title></head>
  <body style="font-family: sans-serif;">
    <h1>${message}</h1>
  </body>
</html>
HTML
