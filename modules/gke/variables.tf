variable "project" {    
    type        = string
    description = "The project ID"
}

variable "gke_readonly_groups" {
    description = "Group list with permission read only gke"
    type        = list(string)
}

variable "role" {
  description = "Role IAM to apply at the members"
  type        = string
}