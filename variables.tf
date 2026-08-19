variable "availability_zones" {
  description = "Availability Zones used by the enterprise infrastructure"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}