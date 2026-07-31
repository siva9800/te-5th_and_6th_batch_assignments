#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

echo "Hello from Gowthami web server" > /var/www/html/index.html