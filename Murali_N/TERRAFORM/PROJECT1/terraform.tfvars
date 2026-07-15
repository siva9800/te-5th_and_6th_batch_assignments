project_name      = "two-tier-app-murali-n"
owner             = "murali-nanabala"
environment       = "dev"
region            = "ap-south-1"
vpc_cidr          = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
availability_zone = "ap-south-1a"
ssh_ingress_cidr  = "10.0.0.0/32"
instance_type_web = "t3.micro"
instance_type_db  = "t3.micro"
allocate_eip      = true
#key_name          = "null"
tags = {
  CostCenter = "demo"
}
