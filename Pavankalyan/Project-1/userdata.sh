#!/bin/bash

set -e

dnf update -y
dnf install -y httpd

systemctl enable --now httpd

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Pavan's Web Server</title>
</head>
<body>
    <h1>Hello from ${owner_name} web server</h1>
    <p>My first AWS two-tier infrastructure project!</p>
    <p>Created using Terraform.</p>
</body>
</html>
EOF