variable "aws_region" {
  description = "AWS region for the project"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "owner_name" {
  description = "Your name for resource tags and webpage"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Your public IP address followed by /32"
  type        = string
}