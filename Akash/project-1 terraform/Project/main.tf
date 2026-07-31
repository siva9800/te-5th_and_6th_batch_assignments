resource "aws_vpc" "main" {
  cidr_block           = var.aws_vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
    environment = "dev"
    owner = "akash"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "public-subnet"
    environment = "dev"
    owner = "akash"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "private-subnet"
    environment = "dev"
    owner = "akash"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gateway-igw"
    environment = "dev"
    owner = "akash"
  }
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_security_group" "web" {
  name        = "web-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH from your public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "db-security-group"
  description = "Allow MySQL from the web security group only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow MySQL from the web tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from Akash web server</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name        = "web-server"
    environment = "dev"
    owner       = "akash"
  }
}

resource "aws_instance" "db" {
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db.id]
  associate_public_ip_address = false

  tags = {
    Name        = "db-server"
    environment = "dev"
    owner       = "akash"
  }
}