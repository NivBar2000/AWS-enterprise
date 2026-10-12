resource "random_password" "directory_admin" {
  length      = 24
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}
