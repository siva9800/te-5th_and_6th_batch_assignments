resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "my-vpc"
    }
  )
}

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidr

  map_public_ip_on_launch = true

  availability_zone = var.availability_zone

  tags = merge(
    local.common_tags,
    {
      Name = "public-subnet"
    }
  )
}

resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_cidr

  availability_zone = var.availability_zone

  tags = merge(
    local.common_tags,
    {
      Name = "private-subnet"
    }
  )
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "my-igw"
    }
  )
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "private-rt"
    }
  )
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "web" {

  name        = "web-sg"
  description = "Web Security Group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "web-sg"
    }
  )
}

resource "aws_security_group" "db" {

  name        = "db-sg"
  description = "Database Security Group"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.web.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "db-sg"
    }
  )
}

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web_key" {
  key_name   = "terraform-web-key"
  public_key = tls_private_key.web_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.web_key.private_key_pem
  filename        = "${path.module}/terraform-web-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "web" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web.id]

  key_name = aws_key_pair.web_key.key_name

  associate_public_ip_address = true

  user_data = file("userdata.sh")

  tags = merge(
    local.common_tags,
    {
      Name = "web-server"
    }
  )
}

resource "aws_instance" "db" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.db.id]

  key_name = aws_key_pair.web_key.key_name

  associate_public_ip_address = false

  tags = merge(
    local.common_tags,
    {
      Name = "db-server"
    }
  )
}