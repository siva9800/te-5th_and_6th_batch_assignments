# ============================================================
# provider.tf
# WHY THIS FILE EXISTS:
# Terraform needs to know two things before it can do anything:
#   1) Which "provider" (cloud) plugin to use — here, AWS.
#   2) Which region of that cloud to talk to.
# Think of this as telling Terraform "which phone number to dial."
# ============================================================

terraform {
  required_version = ">= 1.10.0"
  # Why 1.10+: the "use_lockfile" state-locking feature in backend.tf
  # was only added in Terraform 1.10. Older versions would error out.

  required_providers {
    aws = {
      source  = "hashicorp/aws" # official AWS provider, published by HashiCorp
      version = "~> 5.0"        # "~> 5.0" means "any 5.x version, but not 6.0"
      # Pinning the version stops your code from breaking if AWS provider
      # releases a new major version with breaking changes later.
    }
  }
}

provider "aws" {
  region = var.aws_region
  # We don't hardcode "us-east-1" here — instead we point to a variable
  # (defined in variables.tf) so it's easy to change the region in one place.
}
