locals {
  ### Products projects
  cloudsql_pre_prod_products_projects = ["contoso-development-v2", "contoso-staging-v2", "contoso-stage", "contoso-development"]
  cloudsql_prod_products_projects     = ["contoso-production-v2", "contoso-production"]

  ### Custom Roles

  ### Groups and roles
  cloudsql_groups = {
    "group:cloudsql.client@contoso.co" = { # team.technology@contoso.co
      projects = toset(concat(local.cloudsql_pre_prod_products_projects, local.cloudsql_prod_products_projects)),
      role     = [{ name = "roles/cloudsql.client", custom = false }]
    }
  }

  ### Make 1 dimension list for each project
  cloudsql_flattened_list = flatten([
    for gr, values in local.cloudsql_groups : [
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

## cloudsql
# IAM Members
resource "google_project_iam_member" "cloudsql_iam" {
  for_each = { for item in local.cloudsql_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
