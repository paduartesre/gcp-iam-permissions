locals {
  ### Products projects
  logging_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  logging_prod_products_projects     = ["contoso-production", "contoso-production-v2"]

  ### Custom Roles
  ### Groups and roles
  logging_groups = {
    "group:logging.viewers@contoso.co" = {
      projects = toset(concat(local.logging_pre_prod_products_projects, local.logging_prod_products_projects)),
      role     = [{ name = "roles/logging.viewer", custom = false }]
    }
  }

  ### Make 1 dimension list for each project
  logging_flattened_list = flatten([
    for gr, values in local.logging_groups : [
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

## Logging
# IAM Members
resource "google_project_iam_member" "logging_iam" {
  for_each = { for item in local.logging_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}