terraform {
  backend "gcs" {
    bucket  = "name-bucket"                 #Create previously your bucket GCS to store your state file
    prefix  = "terraform/state"
    credentials = "path/to/your/credenciais.json"
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

module "gcs_iam" {
  source = "./modules/iam"
  
  project = var.project
  role    = "roles/storage.objectViewer"
  members = var.gcs_readonly_groups
}

module "auditlogs_iam" {
  source = "./modules/iam"
  
  project = var.project
  role    = "roles/logging.view"
  members = var.auditlogs_readonly_groups
}

module "gce_iam" {
  source = "./modules/iam"
  
  project = var.project
  role    = "roles/compute.admin"
  members = var.gce_admin_groups
}
