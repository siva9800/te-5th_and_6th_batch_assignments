terraform {
  backend "s3" {
    bucket       = "gowthami-terraform-state-2026"
    key          = "project-1/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}
