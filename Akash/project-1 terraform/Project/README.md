# AWS Terraform Project

This Terraform project provisions a simple AWS environment with:

- 1 VPC
- 1 public subnet
- 1 private subnet
- 1 public web server
- 1 private database server
- A web security group for SSH and HTTP
- A database security group for MySQL access from the web tier

## What it creates

- A VPC with DNS enabled
- A public subnet and a private subnet
- An Internet Gateway and route table for internet access
- An EC2 web server in the public subnet
- An EC2 database server in the private subnet without a public IP
- Terraform outputs for the VPC ID, web public IP, web public URL, and DB private IP

## Prerequisites

Before running Terraform, make sure you have:

- Terraform installed
- AWS CLI configured with valid credentials
- An existing EC2 key pair in the target AWS region
- An S3 bucket for the remote state backend (if using the current backend config)

## Files

- `main.tf` - Main infrastructure resources
- `provider.tf` - AWS provider configuration
- `variable.tf` - Input variables
- `backend.tf` - S3 backend configuration
- `terraform.tfvars` - Variable values
- `output.tf` - Output values

## How to run

1. Change to the project directory:

   ```bash
   cd Project
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review the plan:

   ```bash
   terraform plan
   ```

4. Apply the configuration:

   ```bash
   terraform apply
   ```

5. View the outputs:

   ```bash
   terraform output
   ```

## Notes

- Update `allowed_ssh_cidr` in `terraform.tfvars` with your own public IP CIDR for better security.
- Update `key_name` in `terraform.tfvars` with your actual EC2 key pair name.
- The web server installs Apache and serves a page showing `Hello from Akash web server`.
