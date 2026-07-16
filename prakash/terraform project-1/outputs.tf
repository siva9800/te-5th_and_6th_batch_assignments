# ============================================================
# outputs.tf
# WHY THIS FILE EXISTS:
# After "terraform apply" finishes, Terraform doesn't automatically show
# you useful info like the server's IP — you'd have to go dig through
# the AWS console. "output" blocks print chosen values to your terminal
# right after apply, and let you fetch them later with
# "terraform output <name>" without re-running apply.
# ============================================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "web_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web.public_ip
  # Pulled directly from the resource we created — Terraform knows this
  # value only AFTER AWS assigns it during apply, so it can't be known
  # in advance, only reported afterward.
}

output "web_public_url" {
  description = "URL to view the web server's page in a browser"
  value       = "http://${aws_instance.web.public_ip}"
  # WHY: this just saves you the step of manually prefixing "http://"
  # onto the IP yourself — copy-paste straight into a browser.
}

output "db_private_ip" {
  description = "Private IP address of the database server"
  value       = aws_instance.db.private_ip
  # Note: db has no public_ip attribute available at all, because it
  # was never given one — only private_ip exists for it.
}
