# terraform {
#   backend "gcs" {
#     bucket  = "name-bucket"
#     prefix  = "terraform/state"
#     credentials = "path/to/your/credenciais.json"
#   }
# }

# provider "google" {
#   credentials = file(var.credentials)
#   project     = var.project
#   region      = var.region
# }


############### Modules ####################

module "appengine" {
  source = "./modules/appengine"

  project = var.project
  role    = "roles/appengine.appViewer"
  members = var.appengine_readonly_groups
}

module "bigquery" {
  source = "./modules/bigquery"
  
  project = var.project
  role    = "roles/bigquery.dataViewer"
  bigquery_readonly_groups = var.bigquery_readonly_groups
}

module "cloudbuild" {
  source = "./modules/cloudbuild"
  
  project = var.project
  role    = "roles/cloudbuild.builds.viewer"
  cloudbuild_readonly_groups = var.cloudbuild_readonly_groups
}

module "cloudsql" {
  source = "./modules/cloudsql"
  
  project = var.project
  role    = "roles/cloudsql.viewer"
  cloudsql_readonly_groups = var.cloudsql_readonly_groups
}

module "dialogflow" {
  source = "./modules/dialogflow"
  
  project = var.project  
  role    = "roles/dialogflow.admin"
  dialogflow_readonly_groups = var.dialogflow_readonly_groups
}

module "iam" {
  source = "./modules/iam"
  
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  members = var.members
}

module "firebase" {
  source = "./modules/firebase"
  
  project = var.project
  role    = "roles/firebase.admin"
  firebase_readonly_groups = var.firebase_readonly_groups
}

module "functions" {
  source = "./modules/functions"
  
  project = var.project
  role    = "roles/cloudfunctions.viewer"
  functions_readonly_groups = var.functions_readonly_groups
  
}

module "gce" {
  source = "./modules/gce"

  project                            = var.project
  role                               = "roles/compute.admin"
  gce_readonly_groups                = var.gce_readonly_groups
  gce_YBR_projects                   = var.gce_YBR_projects
  gce_ABC_projects                   = var.gce_ABC_projects 
  gce_stage_projects                 = var.gce_stage_projects
  gce_dev_projects                   = var.gce_dev_projects
  gce_qa_projects                    = var.gce_qa_projects
  gce_prod_TeamXPTO_projects         = var.gce_prod_TeamXPTO_projects
  gce_pre_prod_products_projects     = var.gce_pre_prod_products_projects
  gce_prod_products_projects         = var.gce_prod_products_projects

  gce_YBR_instance                   = var.gce_YBR_instance
  gce_ABC_instance                   = var.gce_ABC_instance
  gce_stage_instance                 = var.gce_stage_instance
  gce_dev_instance                   = var.gce_dev_instance
  gce_qa_instance                    = var.gce_qa_instance
  gce_prod_TeamXPTO_instance         = var.gce_prod_TeamXPTO_instance
  gce_pre_prod_products_instance     = var.gce_pre_prod_products_instance
  gce_prod_products_instance         = var.gce_prod_products_instance

  gce_YBR_instance_name              = var.gce_YBR_instance_name
  gce_ABC_instance_name              = var.gce_ABC_instance_name
  gce_stage_instance_name            = var.gce_stage_instance_name
  gce_dev_instance_name              = var.gce_dev_instance_name
  gce_qa_instance_name               = var.gce_qa_instance_name
  gce_prod_TeamXPTO_instance_name    = var.gce_prod_TeamXPTO_instance_name
  gce_pre_prod_products_instance_name = var.gce_pre_prod_products_instance_name

  gce_YBR_instance_group             = var.gce_YBR_instance_group
  gce_ABC_instance_group             = var.gce_ABC_instance_group
  gce_stage_instance_group           = var.gce_stage_instance_group
  gce_dev_instance_group             = var.gce_dev_instance_group
  gce_qa_instance_group              = var.gce_qa_instance_group
  gce_prod_TeamXPTO_instance_group   = var.gce_prod_TeamXPTO_instance_group
  gce_pre_prod_products_instance_group = var.gce_pre_prod_products_instance_group
}


module "gke" {
  source = "./modules/gke"
  
  project = var.project
  role    = "roles/container.admin"
  gke_readonly_groups = var.gke_readonly_groups  
}

module "integrations" {
  source = "./modules/integrations"
  
  project = var.project
  role    = "roles/cloudfunctions.admin"
  integrations_readonly_groups = var.integrations_readonly_groups  
} 

module "logging" {
  source = "./modules/logging"
  
  project = var.project
  role    = "roles/logging.admin"
  logging_readonly_groups = var.logging_readonly_groups  
}

module "pubsub" {
  source = "./modules/pubsub"
  
  project = var.project
  role    = "roles/pubsub.admin"
  pubsub_readonly_groups = var.pubsub_readonly_groups  
}

module "scheduler" {
  source = "./modules/scheduler"
  
  project = var.project
  role    = "roles/cloudscheduler.admin"
  scheduler_readonly_groups = var.scheduler_readonly_groups
}

module "storage" {  
  source = "./modules/storage"
  
  project = var.project
  role    = "roles/storage.admin"
  storage_readonly_groups = var.storage_readonly_groups
}
