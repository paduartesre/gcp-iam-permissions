variable "project" {    
    type        = string
    description = "The project ID"
}

variable "role" {
  description = "Role IAM to apply at the members"
  type        = string
}

variable "logging_readonly_groups" {
  description = "Group list with permission read only logging"
  type        = list(string)
}