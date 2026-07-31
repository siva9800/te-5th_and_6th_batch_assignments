
# ============================================================

terraform {
  backend "s3" {
    bucket = "prakash-project1-tfstate-bucket"
  
    key = "project-1/terraform.tfstate"
    
    region = "us-east-1"
    
    encrypt = true
   
    use_lockfile = true
  
  }
}
