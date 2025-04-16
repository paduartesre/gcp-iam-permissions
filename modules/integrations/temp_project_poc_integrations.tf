locals {

  temp_project_poc_integrations = "contoso-temp-integrations-poc"

  ### Groups and roles
  poc_integrations_group = {
    "group:squad.integration@contoso.co" = {
      projects = toset([local.temp_project_poc_integrations])
      role = [
        { name = "roles/workflows.admin", custom = false },
        { name = "roles/pubsub.admin", custom = false },
        { name = "roles/cloudfunctions.admin", custom = false },
        { name = "roles/run.admin", custom = false },
        { name = "roles/storage.admin", custom = false },
        { name = "roles/viewer", custom = false },
        { name = "roles/browser", custom = false },
        { name = "roles/iam.serviceAccountUser", custom = false },
        { name = "roles/resourcemanager.projectIamAdmin", custom = false },
        { name = "roles/secretmanager.admin", custom = false },
      ]
    }
  }

  ### Make 1 dimension list for each project
  poc_integrations_flattened_list = flatten([
    for gr, values in local.poc_integrations_group : [
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

## PubSub
# IAM Members
resource "google_project_iam_member" "poc_integrations_iam" {
  for_each = { for item in local.poc_integrations_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}

