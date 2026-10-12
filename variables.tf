variable "availability_zones" {
  description = "Availability Zones used by the enterprise infrastructure"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}
variable "directory_name" {
  description = "Full DNS name of the Active Directory domain"
  type        = string
  default     = "corp.nivlab.internal"
}

variable "directory_short_name" {
  description = "Short NetBIOS name of the Active Directory domain"
  type        = string
  default     = "NIVLAB"
}
variable "management_instance_type" {
  description = "EC2 instance type used by the Windows management server"
  type        = string
  default     = "t3.small"
}