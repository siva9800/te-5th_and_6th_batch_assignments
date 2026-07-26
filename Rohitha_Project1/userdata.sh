#!/bin/bash

yum update -y
yum install -y httpd

systemctl enable httpd
systemctl start httpd

echo "Hello from Rohitha Sandhari web server" > /var/www/html/index.html