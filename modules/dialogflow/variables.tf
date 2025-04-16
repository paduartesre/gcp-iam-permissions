variable "role" {
    description = "Role IAM to apply at the members"
    type        = string
}

variable "dialogflow_readonly_groups" {
  description = "Group list with permission read only Dialogflow"
  type        = list(string)
}

variable "project" {
    type        = string
    description = "The project ID"
}