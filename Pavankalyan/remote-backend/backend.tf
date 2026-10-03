# Remote Backend Configuration using S3 with native state locking
# S3 native locking (Terraform 1.10+) uses a lock file + S3 conditional writes
# No DynamoDB table required.

terraform {
  backend "s3" {
    bucket       = "pavan-devops-s3-demo-987078319571"
    key          = "remote-backend/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    profile      = "cli-user"
    use_lockfile = true # Enable S3 native state locking
  }
}

# NOTE: Before using remote backend, create the S3 bucket using the commands

# 1. Create S3 bucket:
#    aws s3api create-bucket --bucket terraform-state-demo-bucket --region ap-south-1 \
#      --create-bucket-configuration LocationConstraint=ap-south-1

# 2. Enable versioning on S3:
#    aws s3api put-bucket-versioning --bucket terraform-state-demo-bucket \
#      --versioning-configuration Status=Enabled
 