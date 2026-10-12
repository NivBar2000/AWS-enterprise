resource "aws_secretsmanager_secret" "directory_admin" {
  name        = "enterprise-lab/directory-admin-password"
  description = "Admin password for the enterprise lab Managed Microsoft AD"
}

resource "aws_secretsmanager_secret_version" "directory_admin" {
  secret_id = aws_secretsmanager_secret.directory_admin.id

  secret_string = jsonencode({
    username = "Admin"
    password = random_password.directory_admin.result
    domain   = var.directory_name
  })
}