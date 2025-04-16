variable "project" {
  type        = string
  description = "The project ID"
}

variable "role" {
  type        = string
  description = "The role to apply"
}

variable "functions_readonly_groups" {
  description = "Group list with permission read only functions"
  type        = list(string)
}