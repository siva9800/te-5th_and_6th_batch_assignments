# Two-tier Web Application on AWS (Terraform)

This project provisions a simple two-tier setup:
- Public web tier (EC2 in public subnet, Apache installed)
- Private DB tier (EC2 in private subnet, no public IP)
- VPC, subnets, route tables, IGW, and security groups
- Optional Elastic IP for a stable public IP on the web server
- Remote state backend in S3 with DynamoDB state locking

## Architecture
- 1 VPC (10.0.0.0/16)
- 1 Public Subnet (10.0.1.0/24) with auto-assign public IPs
- 1 Private Subnet (10.0.2.0/24)
- Internet Gateway and public route 0.0.0.0/0 via IGW
- Web SG: HTTP from 0.0.0.0/0, SSH only from your IP
- DB SG: MySQL (3306) allowed only from Web SG
- Web EC2 (Apache) and DB EC2 (no public IP)

## Prerequisites
- Terraform >= 1.5
- AWS credentials configured (env vars or profile)
- An S3 bucket and a DynamoDB table for state and locking
  - DynamoDB table must have primary key: LockID (String)

## Setup Backend
Edit backend.tf with:
- bucket
- key (path/name)
- region
- dynamodb_table

## Configure Variables
Edit terraform.tfvars:
- owner, ssh_ingress_cidr, key_name, allocate_eip, etc.

## Commands
```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
