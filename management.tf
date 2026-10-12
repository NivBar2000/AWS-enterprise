data "aws_ssm_parameter" "windows_server_2022_ami" {
  name = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-Base"
}
resource "aws_iam_role" "management_server" {
  name = "enterprise-management-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "enterprise-management-server-role"
  }
}

resource "aws_iam_role_policy_attachment" "management_ssm_core" {
  role       = aws_iam_role.management_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "management_directory_access" {
  role       = aws_iam_role.management_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_instance_profile" "management_server" {
  name = "enterprise-management-server-profile"
  role = aws_iam_role.management_server.name
}
resource "aws_security_group" "management_server" {
  name        = "enterprise-management-server-sg"
  description = "Security group for the private Windows management server"
  vpc_id      = aws_vpc.enterprise.id

  tags = {
    Name = "enterprise-management-server-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "management_server_all_ipv4" {
  security_group_id = aws_security_group.management_server.id
  description       = "Allow outbound traffic through the NAT gateway"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
resource "aws_instance" "management_server" {
  ami           = data.aws_ssm_parameter.windows_server_2022_ami.value
  instance_type = var.management_instance_type
  subnet_id     = aws_subnet.employee_a.id

  vpc_security_group_ids = [
    aws_security_group.management_server.id
  ]

  iam_instance_profile        = aws_iam_instance_profile.management_server.name
  associate_public_ip_address = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  depends_on = [
    aws_vpc_dhcp_options_association.enterprise,
    aws_route.employee_internet,
    aws_iam_role_policy_attachment.management_ssm_core,
    aws_iam_role_policy_attachment.management_directory_access
  ]

  tags = {
    Name = "enterprise-management-server"
    Role = "DirectoryManagement"
  }
}
resource "aws_ssm_association" "management_server_domain_join" {
  name = "AWS-JoinDirectoryServiceDomain"

  targets {
    key = "InstanceIds"
    values = [
      aws_instance.management_server.id
    ]
  }

  parameters = {
    directoryId   = aws_directory_service_directory.enterprise.id
    directoryName = var.directory_name
    dnsIpAddresses = join(
      ",",
      aws_directory_service_directory.enterprise.dns_ip_addresses
    )
  }

  wait_for_success_timeout_seconds = 1800
}