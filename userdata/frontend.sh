#!/bin/bash
yum update -y
yum install -y httpd
echo "Hello from Frontend!" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
