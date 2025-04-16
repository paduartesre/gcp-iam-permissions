locals {
  ### Products projects
  dialogflow_prod_TeamXPTO_projects = ["contoso-TeamXPTO"]

  ### Groups and roles
  # google_project_iam_member
  dialogflow_groups = {
    # TeamXPTO
    "group:dialogflow.TeamXPTO.admin@contoso.co" = {
      projects = toset(concat(local.dialogflow_prod_TeamXPTO_projects)),
      role = [
        { name = "roles/dialogflow.admin", custom = false },
        { name = "roles/dialogflow.aamAdmin", custom = false },
        { name = "roles/dialogflow.webhookAdmin", custom = false },
        { name = "roles/dialogflow.client", custom = false },
      ]
      condition = null
    }
  }

  ### Make 1 dimension list for each project
  dialogflow_flattened_list = flatten([
    for gr, values in local.dialogflow_groups : [
      for pr in values.projects : [
        for rl in values.role : {
          key       = "${gr}-${pr}-${rl.name}"
          project   = pr
          group     = gr
          role      = rl.custom ? "projects/${pr}/${rl.name}" : rl.name
          condition = can(values.condition) ? values.condition : null
        }
      ]
    ]
  ])
}

## dialogflow
# IAM Members
resource "google_project_iam_member" "dialogflow_project_iam" {
  for_each = { for item in local.dialogflow_flattened_list : item.key => item }

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