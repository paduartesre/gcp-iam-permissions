locals {
  ### Products projects
  appengine_pre_prod_products_projects = ["contoso-development-webapps", "contoso-stage"]
  appengine_prod_products_projects     = ["contoso-production", "contoso-marketing"]

  ### Custom Roles

  ### Groups and roles
  appengine_groups = {
    "group:appengine.viewers@contoso.co" = { # team.technology@contoso.co
      projects = toset(concat(local.appengine_pre_prod_products_projects, local.appengine_prod_products_projects)),
      role     = [{ name = "roles/appengine.appViewer", custom = false }]
    }
  }

  ### Make 1 dimension list for each project
  appengine_flattened_list = flatten([
    for gr, values in local.appengine_groups : [
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

## Appengine
# IAM Members
resource "google_project_iam_member" "appengine_iam" {
  for_each = { for item in local.appengine_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
