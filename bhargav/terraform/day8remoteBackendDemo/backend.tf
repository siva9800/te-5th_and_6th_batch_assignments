terraform {
  backend "s3" {
    bucket       = "terraform-state-file-734213567171"
    key          = "remote-backend/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true 
    profile      = "terraform-demo"
  }
}