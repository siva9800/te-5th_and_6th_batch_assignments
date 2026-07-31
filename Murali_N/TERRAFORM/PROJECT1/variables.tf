variable "project_name" {
  type        = string
  description = "Base name for resources"
}

variable "owner" {
  type        = string
  description = "Owner tag"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment tag"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  type        = string
  description = "AZ for subnets (e.g., us-east-1a)"
  default     = null
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "Your IP in CIDR form for SSH (e.g., 203.0.113.5/32)"
}

variable "instance_type_web" {
  type        = string
  default     = "t3.micro"
}

variable "instance_type_db" {
  type        = string
  default     = "t3.micro"
}

variable "allocate_eip" {
  type        = bool
  default     = false
  description = "Attach an Elastic IP to the web server"
}

variable "key_name" {
  type        = string
  default     = null
  description = "EC2 Key Pair name for SSH (optional)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply"
}
