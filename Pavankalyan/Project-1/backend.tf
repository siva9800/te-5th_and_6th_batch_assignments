terraform {
  backend "s3" {
    bucket       = "pavan-devops-s3-demo-987078319571"
    key          = "project-1/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    profile      = "cli-user"
    use_lockfile = true
  }
}