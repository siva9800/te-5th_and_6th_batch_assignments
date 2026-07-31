variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "terraform-project1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change this to your IP for security
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "ap-southeast-2a"
}

variable "owner" {
  description = "owner name"
  type        = string
  default     = "Yasaswini"
}

variable "Environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "key_name" {
  description = "aws key pair"
  type        = string

}
variable "public_subnet2_cidr" {
  description = "CIDR block for public subnet2"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone2" {
  description = "Availability zone for the subnet2"
  type        = string
  default     = "ap-southeast-2b"
}