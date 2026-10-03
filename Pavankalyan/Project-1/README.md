# Project 1: Two-Tier Web Application on AWS

## Overview

This project creates a two-tier AWS infrastructure using Terraform.

The web tier runs Apache on an EC2 instance in a public subnet. The database tier uses a second EC2 instance in a private subnet.

## Resources Created

* One VPC
* One public subnet and one private subnet
* One Internet Gateway
* One public route table and subnet association
* Two security groups
* Two EC2 instances
* An S3 remote backend with state locking

## Prerequisites

* AWS account and suitable IAM permissions
* AWS CLI configured
* Terraform 1.10 or newer
* An existing private S3 bucket for Terraform state

## Deployment Steps

1. Configure the values in `terraform.tfvars`.
2. Configure the S3 backend in `backend.tf`.
3. Run `terraform init`.
4. Run `terraform fmt`.
5. Run `terraform validate`.
6. Run `terraform plan`.
7. Run `terraform apply`.
8. Open the `web_public_url` output in a browser.

## Cleanup

Run `terraform destroy` after completing the project and confirming that the resources can be removed.

The S3 bucket used for Terraform state is managed separately and is not deleted by this project's destroy command.

## Security

* SSH is restricted to the configured public IP.
* HTTP is allowed from the internet.
* MySQL port 3306 is allowed only from the web server security group.
* The private EC2 instance has no public IP.

## Limitations

This project does not install MySQL or configure an actual database. It creates a private EC2 server with the required security group rules.
