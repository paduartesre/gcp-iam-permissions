locals {
  ### Products projects   
  workflows_pre_prod_products_projects = ["contoso-development", "contoso-stage"]
  workflows_prod_products_projects     = ["contoso-production"]

  ### Groups and roles
  workflows_groups = {
    "group:workflows.viewer@contoso.co" = {
      projects = toset(concat(local.workflows_prod_products_projects)),
      role     = [{ name = "roles/workflows.viewer", custom = false }]
    }
    "group:workflows.editor@contoso.co" = {
      projects = toset(concat(local.workflows_pre_prod_products_projects)),
      role     = [{ name = "roles/workflows.editor", custom = false }]
    }
  }

  ### Make 1 dimension list for each project
  workflows_flattened_list = flatten([
    for gr, values in local.workflows_groups : [
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

## Workflows
# IAM Members
resource "google_project_iam_member" "workflows_iam" {
  for_each = { for item in local.workflows_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
