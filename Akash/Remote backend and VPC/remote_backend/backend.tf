terraform {
  backend "s3" {
    bucket       = "terraform-demo-bucket-20260706-akash"
    key          = "remote-backend/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true # Enable S3 native state locking
  }
}

