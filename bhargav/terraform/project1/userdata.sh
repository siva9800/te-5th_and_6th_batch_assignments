#!/bin/bash

dnf update -y

dnf install -y httpd

systemctl enable httpd

systemctl start httpd

echo "Hello from Bhargav web server" > /var/www/html/index.html