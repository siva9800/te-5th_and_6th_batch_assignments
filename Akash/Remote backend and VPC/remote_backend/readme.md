# Remote Backend and VPC - Terraform Project

This Terraform project sets up an AWS VPC with a remote state backend stored in S3, providing a foundation for cloud infrastructure deployments.

## 📋 Project Overview

This project creates:
- **AWS VPC** with configurable CIDR block
- **Internet Gateway** for public internet access
- **Public Subnet** with auto-assigned public IPs
- **Route Table** and associations for traffic routing
- **S3 Remote Backend** for centralized Terraform state management with encryption and locking

## 🏗️ Architecture

```
VPC (10.0.0.0/16)
├── Internet Gateway
├── Public Subnet (10.0.1.0/24)
│   └── Route Table (0.0.0.0/0 → IGW)
└── EC2 Instance (optional - defined in security groups)
```

## 📦 Prerequisites

1. **AWS Account** with appropriate IAM permissions
2. **Terraform** (v1.0+) installed on your local machine
3. **AWS CLI** configured with your credentials:
   ```bash
   aws configure
   ```
4. **S3 Bucket** for remote backend (bucket name must match `backend.tf`)

## 🚀 Quick Start

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan the infrastructure
```bash
terraform plan
```

### 3. Apply the configuration
```bash
terraform apply
```

### 4. Verify outputs
```bash
terraform output
```

## 📝 Configuration Variables

| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `aws_region` | AWS region for resources | `ap-south-1` | string |
| `project_name` | Project name for resource naming | `terraform-demo` | string |
| `vpc_cidr` | CIDR block for VPC | `10.0.0.0/16` | string |
| `public_subnet_cidr` | CIDR block for public subnet | `10.0.1.0/24` | string |
| `instance_type` | EC2 instance type | `t3.micro` | string |
| `availability_zone` | Availability zone for subnet | `ap-south-1a` | string |
| `allowed_ssh_cidr` | CIDR blocks for SSH access | `0.0.0.0/0` | list(string) |
| `ami_id` | AMI ID (Amazon Linux 2) | `ami-0bc7aabcf58d1e02a` | string |

### Customize Variables

**Option 1: Create `terraform.tfvars`**
```hcl
aws_region       = "us-east-1"
project_name     = "my-project"
vpc_cidr         = "10.1.0.0/16"
allowed_ssh_cidr = ["YOUR_IP/32"]
```

**Option 2: Pass at command line**
```bash
terraform apply -var="project_name=my-project" -var="aws_region=us-east-1"
```

## 📤 Outputs

After applying, view outputs with:
```bash
terraform output
```

Available outputs (defined in `output.tf`):
- VPC ID
- Subnet ID
- Internet Gateway ID
- Route Table ID

## 🔐 Remote State Management

State is stored in S3 with:
- ✅ **Encryption** enabled
- ✅ **Locking** enabled (prevents concurrent modifications)
- 📍 **Bucket**: `terraform-demo-bucket-20260706-akash`
- 📍 **Key**: `remote-backend/terraform.tfstate`

## 🧹 Cleanup

To destroy all resources:
```bash
terraform destroy
```

⚠️ **Warning**: This will delete your VPC and associated resources. State files in S3 are retained.

## 📁 File Structure

```
.
├── main.tf              # VPC, subnets, and networking resources
├── backend.tf           # S3 remote backend configuration
├── provider.tf          # AWS provider configuration
├── variable.tf          # Input variables
├── output.tf            # Output values
├── terraform.tfvars     # Variable values (if using local tfvars)
└── readme.md            # This file
```

## 🔧 Common Operations

### Validate configuration
```bash
terraform validate
```

### Format code
```bash
terraform fmt -recursive
```

### Import existing resources
```bash
terraform import aws_vpc.main vpc-xxx
```

### Refresh state
```bash
terraform refresh
```

## 📖 Documentation

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform State & Backends](https://www.terraform.io/language/state)

## ⚠️ Security Notes

1. **SSH Access**: Default allows `0.0.0.0/0` - change to your IP:
   ```hcl
   allowed_ssh_cidr = ["YOUR.IP.ADDRESS/32"]
   ```

2. **State File Encryption**: Ensure S3 bucket has server-side encryption enabled

3. **IAM Permissions**: Use least-privilege principle for AWS credentials

4. **Git**: Add `terraform.tfvars` to `.gitignore` if containing sensitive data

## 🤝 Contributing

1. Test changes with `terraform plan`
2. Follow [Terraform style conventions](https://developer.hashicorp.com/terraform/language/style)
3. Document changes in comments

## 📞 Support

For issues or questions, check:
- Terraform error messages (detailed in console)
- AWS Console for resource status
- CloudTrail logs for API-level issues

---

**Last Updated**: 2026-07-15  
**Terraform Version**: 1.0+  
**AWS Region**: ap-south-1
