# ============================================================
# main.tf
# WHY THIS FILE EXISTS:
# This is the actual blueprint — every AWS resource we want built lives
# here. Terraform reads this file, compares it to what's ALREADY in AWS
# (via the state file), and figures out what to create/change/delete
# to make reality match this file.
# ============================================================

########################################
# DATA SOURCES
# "data" blocks don't CREATE anything — they just LOOK UP information
# that already exists (either in AWS itself, or published by AWS).
########################################

# WHY: instead of hardcoding an AMI ID (like "ami-0abcd1234"), which
# changes every time AWS patches the image and would go stale, we ask
# AWS at apply-time: "give me whatever the newest Amazon Linux 2 AMI is
# right now." This is a stretch goal from the assignment, and it's also
# just better practice — your code never rots.
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"] # only trust images published by AWS itself

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # matches the Amazon Linux 2 naming pattern
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"] # the standard virtualization type for modern EC2 instances
  }
}

# WHY: every AWS region has multiple "Availability Zones" (physically
# separate data centers). We ask AWS to list the available ones so we
# can place our subnet in a valid one, without hardcoding a zone name
# that might not exist in every account/region.
data "aws_availability_zones" "available" {
  state = "available"
}

########################################
# NETWORKING
# Order matters conceptually: VPC first (the container), then subnets
# inside it, then a way in/out (Internet Gateway + route table).
########################################

# The VPC is the isolated virtual network that everything else lives in.
# Nothing inside it is reachable from outside unless we explicitly allow it.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # lets resources inside resolve DNS names
  enable_dns_hostnames = true # gives EC2 instances DNS hostnames, not just IPs

  tags = {
    Name        = "${var.owner_name}-vpc"
    Environment = var.environment
    Owner       = var.owner_name
  }
  # Tagging every resource with Name/Environment/Owner is a real-world
  # best practice — it's how teams tell resources apart in the AWS
  # console and in cost/billing reports.
}

# An Internet Gateway is literally the "door" that lets traffic flow
# between your VPC and the public internet. Without this, NOTHING in
# your VPC — public or private subnet — can reach the internet.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.owner_name}-igw"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

# The PUBLIC subnet — this is where the web server lives.
resource "aws_subnet" "public" {
  vpc_id                   = aws_vpc.main.id
  cidr_block                = var.public_subnet_cidr
  availability_zone         = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch   = true
  # WHY map_public_ip_on_launch = true: this tells AWS "automatically give
  # any EC2 instance launched in this subnet a public IP address." Without
  # this, even a subnet with internet access wouldn't make your server
  # reachable from outside, because the instance itself would have no
  # public IP to be reached AT.

  tags = {
    Name        = "${var.owner_name}-public-subnet"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

# The PRIVATE subnet — this is where the database lives.
# Notice: NO map_public_ip_on_launch here. That's intentional — it's
# what keeps the database unreachable from the public internet.
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.owner_name}-private-subnet"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

# A route table is basically a signpost: "if traffic wants to go to X,
# send it out through Y." Here we say "any traffic headed anywhere
# (0.0.0.0/0) should exit through the Internet Gateway."
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"               # "0.0.0.0/0" means "literally anywhere"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.owner_name}-public-rt"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

# A route table by itself does nothing until it's ATTACHED to a subnet.
# This association is what actually makes the public subnet "public" —
# it's the subnet using this route table (which points to the IGW) that
# gives it internet access. The private subnet has NO such association,
# so it has no route out to the internet at all.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

########################################
# SECURITY GROUPS
# A security group is a virtual firewall attached to an instance.
# It works on an "allow list" model: everything is blocked by default,
# and you explicitly open only the ports/sources you want.
########################################

resource "aws_security_group" "web" {
  name        = "${var.owner_name}-web-sg"
  description = "Allow SSH from my IP and HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    # WHY only my_ip: SSH (port 22) is how you'd log into the server's
    # command line. If this were open to the world (0.0.0.0/0), bots
    # scanning the internet would immediately start trying to brute-force
    # their way in. Restricting to your own IP closes that door.
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # WHY open to everyone: this is a public website — by definition
    # anyone on the internet should be able to view it, so port 80
    # (HTTP) is intentionally open to all.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # "-1" means "all protocols"
    cidr_blocks = ["0.0.0.0/0"]
    # "Egress" = outbound traffic FROM the server. We allow the server
    # to reach out anywhere (e.g. to download updates), which is the
    # standard default.
  }

  tags = {
    Name        = "${var.owner_name}-web-sg"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

resource "aws_security_group" "db" {
  name        = "${var.owner_name}-db-sg"
  description = "Allow MySQL only from the web security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from web SG only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    # THIS IS THE KEY SECURITY IDEA OF THE WHOLE PROJECT:
    # instead of allowing a CIDR range (an IP range) into the database,
    # we allow a SECURITY GROUP — meaning "only instances that are
    # wearing the 'web-sg' badge can talk to this database on port 3306."
    # There is no cidr_blocks entry here at all, which means the database
    # has ZERO path in from the public internet — not even from your
    # own IP. Only the web server can reach it, exactly as required.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.owner_name}-db-sg"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

########################################
# COMPUTE
# The actual EC2 (virtual machine) instances.
########################################

resource "aws_instance" "web" {
  ami                          = data.aws_ami.amazon_linux_2.id
  instance_type                = var.instance_type
  subnet_id                    = aws_subnet.public.id       # placed in the PUBLIC subnet
  vpc_security_group_ids       = [aws_security_group.web.id] # protected by the web SG
  associate_public_ip_address  = true
  key_name                     = var.key_name != "" ? var.key_name : null
  # WHY the "!= "" ? ... : null" logic: if you left key_name blank in
  # tfvars, we pass "null" instead of an empty string, because AWS
  # rejects an empty string but is fine with "no key pair attached."

  user_data = templatefile("${path.module}/userdata.sh.tftpl", {
    owner_name = var.owner_name
  })
  # WHY user_data: this is a script AWS runs automatically the FIRST
  # time the instance boots — it's how we install and start the web
  # server without ever manually logging in. "templatefile" lets us
  # inject var.owner_name into the script so the greeting page says
  # your actual name.

  tags = {
    Name        = "${var.owner_name}-web-server"
    Environment = var.environment
    Owner       = var.owner_name
  }
}

resource "aws_instance" "db" {
  ami                     = data.aws_ami.amazon_linux_2.id
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.private.id          # placed in the PRIVATE subnet
  vpc_security_group_ids  = [aws_security_group.db.id]      # protected by the db SG
  key_name                = var.key_name != "" ? var.key_name : null
  # Notice: NO associate_public_ip_address here, and the private subnet
  # doesn't auto-assign public IPs either — so this instance simply has
  # no public IP at all. That's what "not exposed to the internet" means
  # in practice, not just a firewall rule but literally no reachable
  # address from outside the VPC.

  tags = {
    Name        = "${var.owner_name}-db-server"
    Environment = var.environment
    Owner       = var.owner_name
  }
}
