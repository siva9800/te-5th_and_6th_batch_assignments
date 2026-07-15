terraform {
  backend "s3" {
    bucket       = "muarli-project-1-n"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}
