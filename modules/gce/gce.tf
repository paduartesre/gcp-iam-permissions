locals {
  ### Products projects
  gce_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  gce_prod_products_projects     = ["contoso-production", "contoso-production-v2"]
  gce_prod_TeamXPTO_projects       = ["contoso-TeamXPTO"]

  ### Custom Roles
  gce_TeamXPTO_custom_role = "TeamXPTOComputeStartStopSuspend"

  ### Groups and roles
  # google_project_iam_member
  gce_groups = {
    # General
    "group:gce.viewers@contoso.co" = {
      projects = toset(concat(local.gce_pre_prod_products_projects, local.gce_prod_products_projects)),
      role = [
        { name = "roles/compute.viewer", custom = false }
      ]
      condition = null
    },

    # ABC
    "group:gce.ABC.connectors@contoso.co" = {
      projects = toset(concat(local.gce_pre_prod_products_projects, local.gce_prod_products_projects)),
      role = [
        { name = "roles/compute.osLogin", custom = false }
      ]
      condition = {
        title      = "emulator_specific_instance"
        expression = "resource.type == 'compute.googleapis.com/Instance' && resource.name.extract('/instances/{name}').startsWith('${data.google_compute_instance.emulator_ABC_instance.name}')"
      }
    },

    # TeamXPTO
    "group:gce.TeamXPTO.viewers@contoso.co" = {
      projects = toset(concat(local.gce_prod_TeamXPTO_projects)),
      role = [
        { name = "roles/compute.viewer", custom = false }
      ]
      condition = null
    },
    "group:gce.TeamXPTO.connectors@contoso.co" = {
      projects = toset(["contoso-TeamXPTO"])
      role = [
        { name = "roles/iap.tunnelResourceAccessor", custom = false }
      ]
    },

    # YBR
    "group:gce.YBR.connectors@contoso.co" = {
      projects = toset(["contoso-production"])
      role = [
        { name = "roles/compute.osLogin", custom = false }
      ]
      condition = {
        title = "YBR_qrcode_instance_group"
        # I could not get the instance base name from the instance_group data 
        expression = "resource.type == 'compute.googleapis.com/Instance' && resource.name.extract('/instances/{name}').startsWith('service-worker')"
      }
    }
  }

  ### Make 1 dimension list for each project
  gce_flattened_list = flatten([
    for gr, values in local.gce_groups : [
      for pr in values.projects : [
        for rl in values.role : {
          key       = "${gr}-${pr}-${rl.name}"
          project   = pr
          group     = gr
          role      = rl.custom ? "projects/${pr}/${rl.name}" : rl.name
          condition = can(values.condition) ? values.condition : can(rl.condition) ? rl.condition : null
        }
      ]
    ]
  ])
}

## GCE
# IAM Members
resource "google_project_iam_member" "gce_project_iam" {
  for_each = { for item in local.gce_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group

  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      title      = condition.value.title
      expression = condition.value.expression
    }
  }
}

# TeamXPTO VM
resource "google_compute_instance_iam_member" "allow_TeamXPTO_vm" {
  for_each = { for item in [
    { name = "roles/compute.osLogin", custom = false },
    { name = "roles/${local.gce_TeamXPTO_custom_role}", custom = true },
    { name = "roles/compute.instanceAdmin.v1", custom = false }
  ] : item.name => item }

  project       = data.google_compute_instance.TeamXPTO_instance.project
  zone          = data.google_compute_instance.TeamXPTO_instance.zone
  instance_name = data.google_compute_instance.TeamXPTO_instance.name
  role          = each.value.custom ? "projects/${data.google_compute_instance.TeamXPTO_instance.project}/${each.value.name}" : each.value.name
  member        = "group:gce.TeamXPTO.connectors@contoso.co"
}

# Instances Data
data "google_compute_region_instance_group" "qrcode_YBR_instance_group" {
  name    = "team-xptoab"
  project = "contoso-production"
  region  = "southamerica-east1"
}

data "google_compute_instance" "emulator_ABC_instance" {
  project = "contoso-production"
  name    = "team-xpto123"
  zone    = "southamerica-east1-b"
}

data "google_compute_instance" "TeamXPTO_instance" {
  project = "contoso-TeamXPTO"
  name    = "TeamXPTO-lots"
  zone    = "southamerica-east1-a"
}

# Custom roles
resource "google_project_iam_custom_role" "compute_TeamXPTO_custom_role" {
  for_each = toset(concat(local.gce_prod_TeamXPTO_projects))

  project     = each.value
  role_id     = local.gce_TeamXPTO_custom_role
  title       = "Custom TeamXPTO permission on Compute to Start and Stop instances"
  permissions = ["compute.instances.start", "compute.instances.stop", "compute.instances.suspend"]
}