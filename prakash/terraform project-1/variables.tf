
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
  
}

variable "owner_name" {
  description = "Your name — used in tags and the web page greeting"
  type        = string
  
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "dev"
 
}

variable "my_ip" {
  description = "YOUR public IP in CIDR form, e.g. 203.0.113.10/32 (get it from https://checkip.amazonaws.com)"
  type        = string
  
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
 
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
  # "/24" is a smaller slice of the VPC's range — 256 addresses
  # (10.0.1.0 to 10.0.1.255) — reserved just for the public subnet.
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for both servers"
  type        = string
  default     = "t2.micro"
 
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access (leave empty to skip SSH access / stretch goal)"
  type        = string
  default     = ""
  
}
