variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "my_ip" {
  description = "Your public IP with CIDR"
  type        = string
}

variable "availability_zone" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}

