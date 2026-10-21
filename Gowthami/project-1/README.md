# Project 1 - 2-Tier Web Application Infrastructure on AWS

## Overview
This project provisions a 2-tier web application infrastructure on AWS using Terraform.

## Resources Created
- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- Public Route Table
- Web Security Group
- Database Security Group
- Web EC2 Instance
- Database EC2 Instance
- Remote Backend (S3)
- Outputs

## Prerequisites
- AWS CLI configured
- Terraform installed
- Existing S3 bucket for remote backend

## How to Run

bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply


## Outputs
- VPC ID
- Web Server Public IP
- Web Server Public URL
- Database Private IP

## Destroy Resources

bash
terraform destroy
