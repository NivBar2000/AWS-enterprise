resource "random_password" "employee" {
  for_each = local.employees

  length           = 20
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "!@#$%^&*()-_=+"
}

resource "aws_secretsmanager_secret" "employee_credentials" {
  name        = "enterprise-lab/employee-credentials"
  description = "Initial credentials for enterprise lab employees"

  tags = {
    Name = "enterprise-employee-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "employee_credentials" {
  secret_id = aws_secretsmanager_secret.employee_credentials.id

  secret_string = jsonencode({
    for username, employee in local.employees : username => {
      password   = random_password.employee[username].result
      department = employee.department
      group_name = employee.group_name
    }
  })
}