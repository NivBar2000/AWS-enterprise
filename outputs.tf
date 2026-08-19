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