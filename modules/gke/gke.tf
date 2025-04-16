locals {
  ### Products projects
  gke_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  gke_prod_products_projects     = ["contoso-production", "contoso-production-v2"]

  ### Custom Roles

  ### Groups and roles
  gke_groups = {
    "group:gke.viewers@contoso.co" = {
      projects = toset(concat(local.gke_pre_prod_products_projects, local.gke_prod_products_projects)),
      role = [
        { name = "roles/container.viewer", custom = false }
      ]
    }
  }

  ### Make 1 dimension list for each project
  gke_flattened_list = flatten([
    for gr, values in local.gke_groups : [
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

## GKE
# IAM Members
resource "google_project_iam_member" "gke_iam" {
  for_each = { for item in local.gke_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
