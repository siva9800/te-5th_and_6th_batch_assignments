 HEAD
 HEAD
# te-5th_and_6th_batch_assignments

# Remote Backend and State Locking Demo

## Assignment 1

Completed Terraform Remote Backend assignment
 c9c77f5 (Completed Assignment 1)

This folder demonstrates Terraform's remote backend capabilities and state locking mechanisms using AWS S3 and DynamoDB.

## Architecture

This configuration creates:
- **VPC**: Virtual Private Cloud with custom CIDR block
- **Internet Gateway**: For public internet access
- **Public Subnet**: For the EC2 instance
- **Route Table**: With route to internet gateway
- **Security Group**: Allows SSH (22), HTTP (80), and HTTPS (443)
- **EC2 Instance**: Amazon Linux 2 web server

## Prerequisites

1. AWS Account with credentials configured
2. AWS CLI installed and configured
3. Terraform installed (v1.0+)

## Setup Instructions

### Step 1: Prepare Remote Backend (S3 Only)

Before applying Terraform, create the S3 bucket for state storage:

```bash
# 1. Create S3 bucket for state (replace with unique name)
aws s3api create-bucket \
  --bucket terraform-state-demo-bucket \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

# 2. Enable versioning on the bucket
aws s3api put-bucket-versioning \
  --bucket terraform-state-demo-bucket \
  --versioning-configuration Status=Enabled
```

### Step 2: Update Backend Configuration

Edit `backend.tf` and update the bucket name with your own unique S3 bucket name:

```hcl
terraform {
  backend "s3" {
    bucket  = "your-unique-bucket-name"
    key     = "remote-backend/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
```

### Step 3: Initialize Terraform

```bash
terraform init
```

This will configure the remote backend and migrate any existing state.

### Step 4: Plan and Apply

```bash
# Review the changes
terraform plan

# Apply the configuration
terraform apply
```

## Note: State Management

This configuration uses S3-only backend without DynamoDB locking. This means:

**Advantages:**
- Simpler setup (S3 bucket only)
- Versioning for state history
- Encryption at rest

**Limitations:**
- No distributed locking mechanism
- Multiple concurrent `terraform apply` operations could cause state conflicts
- Suitable for single user or small teams with proper coordination

## Important Files

- `provider.tf` - AWS provider configuration
- `backend.tf` - Remote backend and state locking configuration
- `main.tf` - VPC, subnets, security groups, and EC2 resources
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output values
- `terraform.tfvars` - Variable values

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

To remove the remote backend:

```bash
aws s3 rb s3://your-unique-bucket-name --force
```

## Key Concepts

### S3 Remote Backend Benefits
- **Centralized State**: Single source of truth for infrastructure
- **Security**: State encrypted at rest with S3 encryption
- **Durability**: Automatic backups with S3 replication
- **Versioning**: State history available through S3 versioning
- **Simple Setup**: No additional services like DynamoDB required

## Troubleshooting

### "AccessDenied" Error
- Ensure your AWS credentials have S3 permissions (GetObject, PutObject, DeleteObject)
- Verify the bucket exists in the correct region

### "BadChecksum" Error
- State may be corrupted; check S3 versioning and restore if needed
- Run `terraform init -reconfigure` to reinitialize

### State Conflicts (Multiple Users)
- Since there's no locking, coordinate terraform apply operations with your team
- Use version control and review changes before applying
- Consider adding DynamoDB state locking for team environments

## Additional Resources

- [Terraform Backend Documentation](https://www.terraform.io/language/settings/backends)
- [S3 Backend Configuration](https://www.terraform.io/language/settings/backends/s3)
- [State Locking](https://www.terraform.io/language/state/locking)
 30733f3 (Terraform remote backend assignment)
