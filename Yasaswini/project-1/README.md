# 2-Tier Web Application Infrastructure on AWS using Terraform

## Project Overview

This project provisions a complete **2-tier web application infrastructure** on AWS using **Terraform** as Infrastructure as Code (IaC).

The infrastructure consists of:

* A custom VPC
* Public and Private Subnets
* Internet Gateway
* Route Table
* Security Groups
* Web Server (Public EC2)
* Database Server (Private EC2)
* Remote Terraform State Backend (S3)
* User Data for automatic Apache installation

The project demonstrates how Terraform can automate AWS infrastructure deployment with a single `terraform apply`.

---

# Architecture

```
                   Internet
                       |
               Internet Gateway
                       |
              Public Route Table
                       |
        ----------------------------
        |                          |
 Public Subnet                Private Subnet
 (10.0.1.0/24)               (10.0.2.0/24)
        |                          |
   Web EC2                    Database EC2
 (Apache Server)              (Private Server)
        |
    Elastic IP (Optional)
```

---

# Technologies Used

* Terraform
* AWS EC2
* AWS VPC
* AWS Subnets
* AWS Internet Gateway
* AWS Route Tables
* AWS Security Groups
* Amazon Linux 2
* Apache HTTP Server
* S3 Remote Backend

---

# Project Structure

```
project-1/
│
├── provider.tf
├── backend.tf
├── data.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── userdata.sh
├── README.md
```

---

# Resources Created

## Networking

* VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* Public Route Table
* Route Table Association

## Security

### Web Security Group

* SSH (22) from my public IP
* HTTP (80) from anywhere

### Database Security Group

* MySQL (3306) only from the Web Security Group
* No public access

## Compute

### Web Server

* Public EC2 Instance
* Apache installed automatically using user_data
* Accessible through Public IP

### Database Server

* Private EC2 Instance
* No Public IP

---

# Stretch Goals Implemented

* Latest Amazon Linux 2 AMI using Terraform Data Source
* Elastic IP for Web Server
* SSH Key Pair
* Second Public Subnet
* Second Web Server in another Availability Zone

---

# Prerequisites

Before running the project, install:

* Terraform
* AWS CLI
* Git
* Visual Studio Code

Configure AWS credentials:

```bash
aws configure
```

---

# How to Run

Initialize Terraform

```bash
terraform init
```

Validate configuration

```bash
terraform validate
```

Format files

```bash
terraform fmt
```

Preview infrastructure

```bash
terraform plan
```

Create infrastructure

```bash
terraform apply
```

Type:

```
yes
```

Terraform will create all AWS resources.

---

# Outputs

After successful deployment Terraform displays:

* VPC ID
* Web Server Public IP
* Web Server URL
* Database Private IP

Example:

```
web_public_ip = 15.xxx.xxx.xxx

web_public_url = http://15.xxx.xxx.xxx

db_private_ip = 10.0.2.15
```

---

# Access the Web Server

Open your browser and visit:

```
http://<Web-Public-IP>
```

You should see:

```
Hello welcome to my web server
```

---

# Destroy Infrastructure

To delete all resources:

```bash
terraform destroy
```

Type:

```
yes
```

Terraform will remove every resource created by this project.

---

# Learning Outcomes

This project helped me understand:

* Infrastructure as Code (IaC)
* Terraform Providers
* Terraform Variables
* Terraform Outputs
* Terraform Data Sources
* Terraform Remote Backend
* AWS VPC Networking
* Public and Private Subnets
* Route Tables
* Internet Gateway
* Security Groups
* EC2 Instances
* User Data Scripts
* Elastic IP
* Key Pair Authentication
* Multi-AZ Infrastructure

---

# Author

**Yasaswini Turaka**


