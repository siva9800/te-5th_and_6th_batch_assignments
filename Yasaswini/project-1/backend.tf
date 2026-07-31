terraform {
  backend "s3" {
    bucket       = "project1-s3-9012"
    key          = "project-1/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true # Enable S3 native state locking
  }
}