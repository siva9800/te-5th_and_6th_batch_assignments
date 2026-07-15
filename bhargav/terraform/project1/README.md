# Project 1 - 2 Tier Web Application Infrastructure on AWS using Terraform

## Overview

This project provisions a two-tier AWS infrastructure using Terraform.

The infrastructure consists of:

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- Route Tables
- Security Groups
- Public EC2 Web Server
- Private EC2 Database Server

The web server is deployed in the public subnet and installs Apache automatically using `user_data`.

The database server is deployed in the private subnet and does not have a public IP address.

---

## Architecture

Internet
    |
Internet Gateway
    |
Public Subnet
    |
Web EC2 (Apache)
    |
Private Subnet
    |
DB EC2

---

## Project Structure

```
project1/
│── backend.tf
│── provider.tf
│── main.tf
│── variables.tf
│── terraform.tfvars
│── outputs.tf
│── userdata.sh
│── README.md
```

---

## Resources Created

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- Public Route Table
- Private Route Table
- Route Table Associations
- Web Security Group
- Database Security Group
- Amazon Linux 2023 AMI (Data Source)
- EC2 Web Server
- EC2 Database Server
- SSH Key Pair

---

## Variables

The following values are configured through `terraform.tfvars`.

- AWS Region
- VPC CIDR
- Public Subnet CIDR
- Private Subnet CIDR
- Availability Zone
- Instance Type
- Environment
- Owner
- Public IP for SSH

---

## Backend

Terraform state is stored remotely in Amazon S3 using the S3 backend.

State locking is enabled using:

```
use_lockfile = true
```

---

## Outputs

Terraform outputs:

- VPC ID
- Web Server Public IP
- Web Server URL
- Database Private IP

---

## How to Run

Initialize Terraform

```bash
terraform init
```

Validate configuration

```bash
terraform validate
```

Preview changes

```bash
terraform plan
```

Deploy infrastructure

```bash
terraform apply
```

Destroy infrastructure

```bash
terraform destroy
```

---

## Web Server

After deployment, open:

```
http://<web_public_ip>
```

Example:

```
http://65.0.168.104
```

Expected Output:

```
Hello from Bhargav web server
```

---

## Author

Bhargav