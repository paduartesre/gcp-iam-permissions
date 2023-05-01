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

variable "gcs_readonly_groups" {
  description = "Group list with permission read only buckets GCS"
  type        = list(string)
}

variable "auditlogs_readonly_groups" {
  description = "Group list with permissions read only audit logs"
  type        = list(string)
}

variable "gce_admin_groups" {
  description = "Group list with permission create, update and delete virtual machines GCE"
  type        = list(string)
}
