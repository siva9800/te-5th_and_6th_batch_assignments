# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.Environment
    Owner       = var.owner
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.Environment
    Owner       = var.owner
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.Environment
    Owner       = var.owner
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  #  map_private_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-private-subnet"
    Environment = var.Environment
    Owner       = var.owner
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.Environment
    Owner       = var.owner
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for web EC2
resource "aws_security_group" "web-ec2" {
  name_prefix = "${var.project_name}-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
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

resource "aws_instance" "db" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db-ec2.id]

  tags = {
    Name        = "${var.project_name}-db-server"
    Environment = var.Environment
    Owner       = var.owner
  }
}

resource "aws_security_group" "db-ec2" {
  name_prefix = "${var.project_name}-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    #  security_groups = [aws_security_group.web-ec2_sg.id]
    security_groups = [aws_security_group.web-ec2.id]
  }
  tags = {
    Name        = "${var.project_name}-ec2-sg"
    Environment = var.Environment
    Owner       = var.owner
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web-ec2.id]

  user_data = file("userdata.sh")

  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.Environment
    Owner       = var.owner
  }
}

resource "aws_eip" "web_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-eip"
    Environment = var.Environment
    Owner       = var.owner
  }
}

resource "aws_eip_association" "web" {
  allocation_id = aws_eip.web_eip.id
  instance_id   = aws_instance.web.id
}

resource "aws_subnet" "public2" {

  cidr_block        = var.public_subnet2_cidr
  availability_zone = var.availability_zone2

  map_public_ip_on_launch = true

  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-public2"
    Environment = var.Environment
    Owner       = var.owner
  }
}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id

}

resource "aws_instance" "web2" {

  ami = data.aws_ami.amazon_linux2.id

  instance_type = var.instance_type

  subnet_id = aws_subnet.public2.id
  key_name  = var.key_name

  vpc_security_group_ids = [
    aws_security_group.web-ec2.id
  ]

  user_data = file("userdata.sh")
  tags = {
    Name        = "${var.project_name}-web2"
    Environment = var.Environment
    Owner       = var.owner
  }
}
