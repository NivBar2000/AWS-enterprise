resource "aws_iam_role" "workspaces_default" {
  name = "workspaces_DefaultRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"

        Principal = {
          Service = "workspaces.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "workspaces-default-role"
  }
}

resource "aws_iam_role_policy_attachment" "workspaces_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}

resource "aws_iam_role_policy_attachment" "workspaces_self_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}
resource "aws_workspaces_directory" "enterprise" {
  directory_id = aws_directory_service_directory.enterprise.id

  subnet_ids = [
    aws_subnet.employee_a.id,
    aws_subnet.employee_b.id
  ]

  workspace_type = "PERSONAL"

  self_service_permissions {
    change_compute_type  = false
    increase_volume_size = false
    rebuild_workspace    = false
    restart_workspace    = true
    switch_running_mode  = false
  }

  workspace_creation_properties {
    enable_internet_access              = false
    enable_maintenance_mode             = true
    user_enabled_as_local_administrator = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_service_access,
    aws_iam_role_policy_attachment.workspaces_self_service_access
  ]

  tags = {
    Name = "enterprise-workspaces-directory"
  }
}
resource "aws_kms_key" "workspaces" {
  description             = "KMS key for enterprise employee WorkSpaces"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name = "enterprise-workspaces-key"
  }
}

resource "aws_kms_alias" "workspaces" {
  name          = "alias/enterprise-workspaces"
  target_key_id = aws_kms_key.workspaces.key_id
}
data "aws_workspaces_bundle" "employee_windows" {
  bundle_id = "wsb-fb2xfp6r8"
}

resource "aws_workspaces_workspace" "employee" {
  for_each = local.employees

  directory_id = aws_workspaces_directory.enterprise.id
  bundle_id    = data.aws_workspaces_bundle.employee_windows.id
  user_name    = each.key

  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key          = aws_kms_key.workspaces.arn

  workspace_properties {
    compute_type_name                         = "VALUE"
    root_volume_size_gib                      = 80
    user_volume_size_gib                      = 10
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

  tags = {
    Name       = "enterprise-workspace-${each.key}"
    User       = each.key
    Department = each.value.department
  }

  depends_on = [
    aws_ssm_association.configure_active_directory
  ]

  timeouts {
    create = "60m"
    delete = "30m"
  }
}