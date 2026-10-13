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
output "workspaces_registration_code" {
  description = "Registration code employees use in the Amazon WorkSpaces client"
  value       = aws_workspaces_directory.enterprise.registration_code
}

output "employee_credentials_secret_arn" {
  description = "ARN of the secret containing the initial employee credentials"
  value       = aws_secretsmanager_secret.employee_credentials.arn
}

output "workspaces_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt employee WorkSpaces"
  value       = aws_kms_key.workspaces.arn
}

output "employee_workspaces" {
  description = "Details of the WorkSpace assigned to each employee"

  value = {
    for username, workspace in aws_workspaces_workspace.employee : username => {
      workspace_id  = workspace.id
      computer_name = workspace.computer_name
      private_ip    = workspace.ip_address
      state         = workspace.state
      department    = local.employees[username].department
    }
  }
}