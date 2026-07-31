variable "aws_region" {
    description = "The AWS region to deploy resources in."
    type        = string
    default     = "ap-south-1"
}

variable "aws_profile" {
    description = "The AWS profile to use for authentication."
    type        = string
    default     = "default"
}

variable "s3_bucket" {
    description = "The name of the S3 bucket to use for Terraform state storage."
    type        = string
    default     = "terraform-demo-bucket-20260706-akash"
}

variable "s3_key" {
    description = "The key for the Terraform state file in the S3 bucket."
    type        = string
    default     = "remote.backend/terraform.tfstate"
}

variable "aws_vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
    description = "The CIDR block for the first public subnet."
    type        = string
    default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_block_2" {
    description = "The CIDR block for the second public subnet."
    type        = string
    default     = "10.0.3.0/24"
}

variable "availability_zone" {
    description = "The availability zone for the first public subnet."
    type        = string
    default     = "ap-south-1a"
}

variable "availability_zone_2" {
    description = "The availability zone for the second public subnet."
    type        = string
    default     = "ap-south-1b"
}

variable "private_subnet_cidr_block" {
    description = "The CIDR block for the private subnet."
    type        = string
    default     = "10.0.2.0/24"
}

variable "allowed_ssh_cidr" {
    description = "CIDR block allowed to SSH into the web server. Replace this with your public IP in CIDR format, for example 203.0.113.10/32."
    type        = string
    default     = "203.0.113.10/32"
}

variable "aws_ami_id" {
    description = "The AMI ID for the EC2 instance."
    type        = string
    default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
}

variable "aws_instance_type" {
    description = "The instance type for the EC2 instance."
    type        = string
    default     = "t2.micro"
}

variable "key_name" {
    description = "The name of the EC2 key pair to use for SSH access."
    type        = string
    default     = "akash-key"
}
