variable "role" {    
    type        = string
    description = "The role to use for GCE"
}

variable "project" {    
    type        = string
    description = "The project ID"
}

variable "cloudbuild_readonly_groups" {    
    type        = list(string)
    description = "The members to use for AppEngine"
}
