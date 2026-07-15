output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "web_public_ip" {
  value       = var.allocate_eip ? aws_eip.web[0].public_ip : aws_instance.web.public_ip
  description = "Public IP of the web server"
}

output "web_public_url" {

  value = var.allocate_eip ? aws_eip.web[0].public_ip : aws_instance.web.public_ip
  description = "URL to reach the web server"
}

output "db_private_ip" {
  value       = aws_instance.db.private_ip
  description = "Private IP of the DB server"
}
