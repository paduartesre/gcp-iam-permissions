variable "project" {
  description = "Project ID GCP"
  type        = string
}

variable "role" {
  description = "Role IAM to apply at the members"
  type        = string
}

variable "members" {
  description = "Groups list to apply permissions IAM"
  type        = list(string)
}
