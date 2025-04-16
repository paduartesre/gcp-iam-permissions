variable "credentials" {
  description = "credentials to access"
  type        = string
}

variable "project" {
  description = "Project ID GCP"
  type        = string
}

variable "region" {
  description = "Region GCP"
  type        = string
  default     = "us-central1"
}

variable "appengine_readonly_groups" {
  description = "Group list with permission read only AppEngine"
  type        = list(string)
}

variable "bigquery_readonly_groups" {    
    type        = list(string)
    description = "The members to use for BigQuery"
}


variable "cloudbuild_readonly_groups" {
  description = "Group list with permission read only Cloud Build"
  type        = list(string)
}

variable "dialogflow_readonly_groups" {
  description = "Group list with permission read only Dialogflow"
  type        = list(string)
}

variable "cloudsql_readonly_groups" {
  description = "Group list with permission read only Cloud SQL"
  type        = list(string)
}

variable "role" {
  description = "Role IAM to apply at the members"
  type        = string
}

variable "members" {
  description = "Groups list to apply permissions IAM"
  type        = list(string)
}

variable "functions_readonly_groups" {
  description = "Group list with permission read only functions"
  type        = list(string)
}

variable "firestore_readonly_groups" {  
  description = "Group list with permission read only firestore"
  type        = list(string)  
}

variable "gce_readonly_groups" {
  description = "Group list with permission read only gce"
  type        = list(string)
} 

variable "gcs_readonly_groups" {
  description = "Group list with permission read only buckets GCS"
  type        = list(string)
}

variable "firebase_readonly_groups" {
  description = "Group list with permission read only firebase"
  type        = list(string)
}

variable "gce_prod_TeamXPTO_instance_name" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for TeamXPTO"
}


variable "gce_YBR_projects" {
  type        = list(string)
  description = "The project ID"
}

variable "gce_ABC_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_stage_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_qa_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_prod_TeamXPTO_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_pre_prod_products_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_prod_products_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gce_qa_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_stage_instance_group" {
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

variable "gce_prod_products_instance_group" {
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

variable "gce_YBR_instance_group" {
    type        = string
    description = "The project ID"  
}

variable "gce_ABC_instance_group" {
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

variable "gce_prod_TeamXPTO_instance" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for TeamXPTO"
}

variable "gce_pre_prod_products_instance" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for pre prod products"
}

variable "gce_prod_products_instance" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for prod products"
}

variable "gce_stage_instance_name" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for stage"
}

variable "gce_qa_instance_name" {
  type        = string  
  default     = "my-default-instance-name"
  description = "The instance name for qa"
}

variable "gce_YBR_instance_name" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for YBR"
}

variable "gce_ABC_instance_name" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for ABC"
}

variable "gce_dev_instance_name" {
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for dev"
}

variable "gce_dev_instance_group" {  
    type        = string
    description = "The project ID"
}

variable "gce_pre_prod_products_instance_name" {  
  type        = string
  default     = "my-default-instance-name"
  description = "The instance name for pre prod products"
}

variable "gce_dev_projects" {
    type        = list(string)
    description = "The project ID"  
}

variable "gke_readonly_groups" {
    description = "Group list with permission read only gke"
    type        = list(string)
}

variable "integrations_readonly_groups" {
  description = "Group list with permission read only integrations"
  type        = list(string)
}


variable "logging_readonly_groups" {
  description = "Group list with permission read only logging"
  type        = list(string)
}

variable "pubsub_readonly_groups" {
  description = "Group list with permission read only pubsub"
  type        = list(string)    
}

variable "scheduler_readonly_groups" {
  description = "Group list with permission read only scheduler"
  type        = list(string)
}

variable "storage_readonly_groups" {
  description = "Group list with permission read only storage"
  type        = list(string)
}

variable "workflows_readonly_groups" {  
  description = "Group list with permission read only workflows"
  type        = list(string)
}