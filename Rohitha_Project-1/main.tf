resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "project-1-vpc"
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidr

  map_public_ip_on_launch = true

  tags = {
    Name        = "project-1-public-subnet"
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_cidr

  tags = {
    Name        = "project-1-private-subnet"
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "project-1-igw"
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.main.id

  }

  tags = {

    Name = "project-1-public-route-table"

    Environment = var.environment

    Owner = var.owner
  }
}

resource "aws_route_table_association" "public" {

  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id

}

resource "aws_security_group" "web" {

  name = "web-sg"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [var.my_ip]
  }

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {

    Name = "project-1-web-sg"

    Environment = var.environment

    Owner = var.owner
  }
}

resource "aws_security_group" "db" {

  name = "db-sg"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [aws_security_group.web.id]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {

    Name = "project-1-db-sg"

    Environment = var.environment

    Owner = var.owner
  }
}

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = "t3.micro"

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = file("${path.module}/userdata.sh")

  tags = {

    Name = "project-1-web-server"

    Environment = var.environment

    Owner = var.owner
  }
}

resource "aws_instance" "db" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = "t3.micro"

  subnet_id = aws_subnet.private.id

  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {

    Name = "project-1-db-server"

    Environment = var.environment

    Owner = var.owner
  }
}