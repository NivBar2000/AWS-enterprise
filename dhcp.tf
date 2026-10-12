resource "aws_vpc_dhcp_options" "enterprise" {
  domain_name         = var.directory_name
  domain_name_servers = aws_directory_service_directory.enterprise.dns_ip_addresses

  tags = {
    Name = "enterprise-ad-dhcp-options"
  }
}

resource "aws_vpc_dhcp_options_association" "enterprise" {
  vpc_id          = aws_vpc.enterprise.id
  dhcp_options_id = aws_vpc_dhcp_options.enterprise.id
}