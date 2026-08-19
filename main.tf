resource "aws_vpc" "enterprise" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "enterprise-vpc"
  }
}
resource "aws_subnet" "ad_a" {
  vpc_id                  = aws_vpc.enterprise.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "enterprise-ad-subnet-a"
    Tier = "AD"
  }
}
resource "aws_subnet" "ad_b" {
  vpc_id                  = aws_vpc.enterprise.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "enterprise-ad-subnet-b"
    Tier = "AD"
  }
}
resource "aws_subnet" "employee_a" {
  vpc_id                  = aws_vpc.enterprise.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "enterprise-employee-subnet-a"
    Tier = "Employee"
  }
}
resource "aws_subnet" "employee_b" {
  vpc_id                  = aws_vpc.enterprise.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "enterprise-employee-subnet-b"
    Tier = "Employee"
  }
}
resource "aws_route_table" "ad_private" {
  vpc_id = aws_vpc.enterprise.id

  tags = {
    Name = "enterprise-ad-private-rt"
    Tier = "AD"
  }
}
resource "aws_route_table_association" "ad_a_to_ad_private" {
  subnet_id      = aws_subnet.ad_a.id
  route_table_id = aws_route_table.ad_private.id
}
resource "aws_route_table_association" "ad_b_to_ad_private" {
  subnet_id      = aws_subnet.ad_b.id
  route_table_id = aws_route_table.ad_private.id
}
resource "aws_route_table" "employee_private" {
  vpc_id = aws_vpc.enterprise.id

  tags = {
    Name = "enterprise-employee-private-rt"
    Tier = "Employee"
  }
}
resource "aws_route_table_association" "employee_a_to_employee_private" {
  subnet_id      = aws_subnet.employee_a.id
  route_table_id = aws_route_table.employee_private.id
}
resource "aws_route_table_association" "employee_b_to_employee_private" {
  subnet_id      = aws_subnet.employee_b.id
  route_table_id = aws_route_table.employee_private.id
}