locals {
  ### Products projects
  cloudscheduler_pre_prod_products_projects = ["contoso-stage", "contoso-development"]
  cloudscheduler_prod_products_projects     = ["contoso-production"]

  ### Custom Roles

  ### Groups and roles
  cloudscheduler_groups = {
    "group:cloudscheduler.jobrunner@contoso.co" = {
      projects = toset(concat(local.cloudscheduler_pre_prod_products_projects, local.cloudscheduler_prod_products_projects)),
      role = [
        { name = "roles/cloudscheduler.jobRunner", custom = false },
        { name = "roles/cloudscheduler.viewer", custom = false }
      ]
    }
  }

  ### Make 1 dimension list for each project
  cloudscheduler_flattened_list = flatten([
    for gr, values in local.cloudscheduler_groups : [
      for pr in values.projects : [
        for rl in values.role : {
          key     = "${gr}-${pr}-${rl.name}"
          project = pr
          group   = gr
          role    = rl.custom ? "projects/${pr}/${rl.name}" : rl.name
        }
      ]
    ]
  ])
}

## cloudscheduler
# IAM Members
resource "google_project_iam_member" "cloudscheduler_iam" {
  for_each = { for item in local.cloudscheduler_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
