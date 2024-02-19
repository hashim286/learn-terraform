#!/bin/bash -xe
yum install httpd -y
systemctl enable httpd.service
systemctl start httpd.service
aws s3 cp s3://hr-bucket-123/index.html /var/www/html/
aws s3 cp s3://hr-bucket-123/error.html /var/www/html/