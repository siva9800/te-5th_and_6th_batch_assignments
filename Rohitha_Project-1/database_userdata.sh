#!/bin/bash

yum update -y

yum install mariadb105-server -y

systemctl start mariadb

systemctl enable mariadb