locals {
  projects = ["contoso-codes"]

  ### Groups and roles
  cloudbuild_groups = {
    "group:cloudbuild.builds.viewers@contoso.co" = {
      projects = toset(concat(local.projects)),
      role = [
        { name = "roles/cloudbuild.builds.viewer", custom = false }
      ]
    }
  }

  ### Make 1 dimension list for each project
  cloudbuild_flattened_list = flatten([
    for gr, values in local.cloudbuild_groups : [
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

## Cloud Build
# IAM Members
resource "google_project_iam_member" "cloudbuild_iam" {
  for_each = { for item in local.cloudbuild_flattened_list : item.key => item }

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
