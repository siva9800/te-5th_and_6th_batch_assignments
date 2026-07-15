terraform {
  backend "s3" {
    bucket       = "bhargav-terraform-state-734213567171"
    key          = "project1/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}