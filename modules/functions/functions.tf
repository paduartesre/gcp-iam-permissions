locals {
  ### Products projects   
  functions_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  functions_prod_products_projects     = ["contoso-production", "contoso-production-v2"]

  ### Custom Roles
  cloudfunctions_developer_custom_roles = "contosoCloudFunctionDeveloper"

  ### Groups and roles
  functions_groups = {
    "group:functions.viewers@contoso.co" = {
      projects = toset(concat(local.functions_pre_prod_products_projects, local.functions_prod_products_projects)),
      role     = [{ name = "roles/cloudfunctions.viewer", custom = false }]
    }
    "group:functions.developers@contoso.co" = {
      projects = toset(concat(local.functions_pre_prod_products_projects)),
      role     = [{ name = "roles/${local.cloudfunctions_developer_custom_roles}", custom = true }]
    }
  }

  ### Make 1 dimension list for each project
  functions_flattened_list = flatten([
    for gr, values in local.functions_groups : [
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

## Functions
# IAM Members
resource "google_project_iam_member" "functions_iam" {
  for_each = { for item in local.functions_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}

resource "google_project_iam_custom_role" "cloudfunctions_developer_roles" {
  for_each = toset(concat(local.functions_pre_prod_products_projects))

  project     = each.value
  role_id     = local.cloudfunctions_developer_custom_roles
  title       = "Custom couldfunctions permission"
  permissions = ["cloudfunctions.functions.call", "cloudfunctions.functions.get", "cloudfunctions.functions.invoke", "cloudfunctions.functions.list", "cloudfunctions.functions.sourceCodeGet"]
}