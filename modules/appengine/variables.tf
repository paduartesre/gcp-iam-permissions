variable "role" {    
    type        = string
    description = "The role to use for AppEngine"
}

variable "project" {    
    type        = string
    description = "The project ID"
}

variable "members" {    
    type        = list(string)
    description = "The members to use for AppEngine"
    default = [ "allUsers" ]
}