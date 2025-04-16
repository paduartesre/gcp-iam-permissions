variable "project" {
    type        = string
    description = "The project ID"
}

variable "gce_readonly_groups" {
    description = "Group list with permission read only gce"
    type        = list(string)
}   

variable "gce_prod_TeamXPTO_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_prod_products_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_pre_prod_products_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_stage_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_dev_projects" {
    type        = list(string)
    description = "The project ID"  
} 

variable "gce_qa_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_ABC_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_prod_TeamXPTO_instance" {
    type        = string
    description = "The project ID"  
}

variable "gce_prod_products_instance" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for prod products"
}

variable "gce_pre_prod_products_instance" {
    type        = string
    description = "The project ID"  
}

variable "gce_stage_instance" {
    type        = string
    description = "The project ID"  
}

variable "gce_dev_instance" {
    type        = string
    description = "The project ID"  
}

variable "gce_qa_instance" {
    type        = string
    description = "The project ID"  
}   

variable "gce_YBR_instance" {
    type        = string
    description = "The project ID"  
}

variable "gce_ABC_instance" {
    type        = string
    description = "The project ID"  
}

variable "gce_prod_TeamXPTO_instance_name" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for TeamXPTO"
}

variable "gce_pre_prod_products_instance_name" {
    type        = string
    description = "The project ID"  
}

variable "gce_stage_instance_name" {
    type        = string
    description = "The project ID"  
}

variable "gce_dev_instance_name" {
    type        = string
    description = "The project ID"  
}

variable "gce_qa_instance_name" {
    type        = string
    description = "The project ID"  
}

variable "gce_YBR_instance_name" {
    type        = string
    description = "The project ID"  
}   

variable "gce_ABC_instance_name" {
    type        = string
    description = "The project ID"  
}

variable "gce_prod_TeamXPTO_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_pre_prod_products_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_stage_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_dev_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_qa_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_YBR_instance_group" {
    type        = string    
    description = "The project ID"  
}

variable "gce_ABC_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_YBR_projects" {
  type        = list(string)
  description = "The project ID"
}

variable "role" {
  type        = string
  description = "The role to use for GCE"
}