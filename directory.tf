resource "aws_directory_service_directory" "enterprise" {
  name       = var.directory_name
  short_name = var.directory_short_name
  password   = random_password.directory_admin.result

  type    = "MicrosoftAD"
  edition = "Standard"

  vpc_settings {
    vpc_id = aws_vpc.enterprise.id

    subnet_ids = [
      aws_subnet.ad_a.id,
      aws_subnet.ad_b.id
    ]
  }

  tags = {
    Name = "enterprise-managed-ad"
  }
}