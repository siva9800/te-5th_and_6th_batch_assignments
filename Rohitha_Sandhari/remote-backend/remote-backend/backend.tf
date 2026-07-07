# Remote Backend Configuration using S3 with native state locking
# S3 native locking (Terraform 1.10+) uses a lock file + S3 conditional writes.
# No DynamoDB table required.

terraform {
  backend "s3" {
    bucket       = "terraform-state-demo-882470096879"
    key          = "remote-backend/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true # Enable S3 native state locking
  }
}

# NOTE: Before using remote backend, create the S3 bucket using the commands below:
#
# 1. Create S3 bucket:
#    aws s3api create-bucket --bucket terraform-state-demo-bucket --region ap-south-1 \
#      --create-bucket-configuration LocationConstraint=ap-south-1
#
# 2. Enable versioning on S3:
#    aws s3api put-bucket-versioning --bucket terraform-state-demo-bucket \
#      --versioning-configuration Status=Enabled
#
# To initialize with remote backend:
#    terraform init
#
# The backend configuration can also be provided via backend config arguments:
#    terraform init -backend-config="bucket=your-bucket" -backend-config="key=path/to/state"
#
# State locking: use_lockfile = true stores a <key>.tflock object in the same
# bucket and uses S3 conditional writes to guarantee only one apply runs at a time.
