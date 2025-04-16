variable "project" {    
    type        = string
    description = "The project ID"
}

variable "role" {
  description = "Role IAM to apply at the members"
  type        = string
}

variable "scheduler_readonly_groups" {
  description = "Group list with permission read only scheduler"
  type        = list(string)
}
