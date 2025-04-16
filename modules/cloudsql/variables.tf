variable "role" {
    description = "Role IAM to apply at the members"
    type        = string

}

variable "project" {
    type        = string
    description = "The project ID"
}

variable "cloudsql_readonly_groups" {
    description = "Group list with permission read only cloudsql"
    type        = list(string)
}