output "vpc_id" {
  description = "ID of the enterprise VPC"
  value       = aws_vpc.enterprise.id
}
output "ad_subnet_ids" {
  description = "IDs of the Active Directory subnets"
  value = [
    aws_subnet.ad_a.id,
    aws_subnet.ad_b.id
  ]
}

output "employee_subnet_ids" {
  description = "IDs of the employee subnets"
  value = [
    aws_subnet.employee_a.id,
    aws_subnet.employee_b.id
  ]
}
output "directory_id" {
  description = "ID of the Managed Microsoft AD directory"
  value       = aws_directory_service_directory.enterprise.id
}

output "directory_dns_ip_addresses" {
  description = "DNS IP addresses of the Managed Microsoft AD directory"
  value       = aws_directory_service_directory.enterprise.dns_ip_addresses
}

output "directory_admin_secret_arn" {
  description = "ARN of the secret containing the directory administrator credentials"
  value       = aws_secretsmanager_secret.directory_admin.arn
}

output "management_server_id" {
  description = "ID of the Windows management server"
  value       = aws_instance.management_server.id
}

output "management_server_private_ip" {
  description = "Private IP address of the Windows management server"
  value       = aws_instance.management_server.private_ip
}