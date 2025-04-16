variable "project" {
  type        = string
  description = "The project ID"
}

variable "role" {
  type        = string
  description = "The role to apply"
}

variable "firebase_readonly_groups" {
  description = "Group list with permission read only firebase"
  type        = list(string)
}