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