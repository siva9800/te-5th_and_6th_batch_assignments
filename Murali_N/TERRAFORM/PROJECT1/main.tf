locals {
  common_tags = merge({
    Name        = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }, var.tags)
}

# Data source for latest Amazon Linux 2 AMI (x86_64)
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags                    = merge(local.common_tags, { Name = "${var.project_name}-public-subnet" })
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  tags              = merge(local.common_tags, { Name = "${var.project_name}-private-subnet" })
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group: Web
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP from anywhere and SSH from my IP"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-web-sg" })
}

# Security Group: DB
resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MySQL from web SG only"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "MySQL from web SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-db-sg" })
}

# User data for web server (Apache + Hello page)
data "template_file" "userdata_web" {
  template = file("${path.module}/userdata.sh")
  vars = {
    message = "Hello from ${var.owner} web server"
  }
}

# Web EC2 (public)
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.instance_type_web
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  #key_name                    = var.key_name
  user_data                   = data.template_file.userdata_web.rendered

  tags = merge(local.common_tags, { Name = "${var.project_name}-web" })
}

# Optional EIP for web
resource "aws_eip" "web" {
  count    = var.allocate_eip ? 1 : 0
  instance = aws_instance.web.id
  domain   = "vpc"
  tags     = merge(local.common_tags, { Name = "${var.project_name}-eip" })
}

# DB EC2 (private)
resource "aws_instance" "db" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.instance_type_db
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.db.id]
  associate_public_ip_address = false
  #key_name                    = var.key_name

  # Placeholder — no actual DB install to keep simple
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              # Example: install mysql server or client if desired
              EOF

  tags = merge(local.common_tags, { Name = "${var.project_name}-db" })
}
