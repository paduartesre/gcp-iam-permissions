locals {
  ### Products projects
  bigquery_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  bigquery_prod_products_projects     = ["contoso-production", "contoso-production-v2"]
  bigquery_prod_TeamXPTO_projects       = ["contoso-TeamXPTO"]

  ### Custom Roles

  ### Groups and roles
  bigquery_groups = {
    "group:bigquery.jobUser@contoso.co" = {
      projects = toset(concat(local.bigquery_pre_prod_products_projects, local.bigquery_prod_products_projects)),
      role     = [{ name = "roles/bigquery.jobUser", custom = false }]
    },
    # TeamXPTO
    "group:bigquery.TeamXPTO.dataViewer@contoso.co" = {
      projects = toset(concat(local.bigquery_prod_TeamXPTO_projects)),
      role     = [{ name = "roles/bigquery.dataViewer", custom = false }]
    },

  }

  ### Make 1 dimension list for each project
  bigquery_flattened_list = flatten([
    for gr, values in local.bigquery_groups : [
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

## Big Query
# IAM Members
resource "google_project_iam_member" "bigquery_iam" {
  for_each = { for item in local.bigquery_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
