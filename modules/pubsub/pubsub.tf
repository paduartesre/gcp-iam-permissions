locals {
  ### Products projects
  pubsub_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  pubsub_prod_products_projects     = ["contoso-production", "contoso-production-v2"]

  ### Custom Roles
  pubsub_custom_role = "contosoPubSubPublisher"

  ### Groups and roles
  pubsub_groups = {
    "group:pubsub.viewers@contoso.co" = {
      projects = toset(concat(local.pubsub_pre_prod_products_projects, local.pubsub_prod_products_projects)),
      role     = [{ name = "roles/pubsub.viewer", custom = false }]
    }
    "group:pubsub.publisher@contoso.co" = {
      projects = toset(concat(local.pubsub_pre_prod_products_projects))
      role     = [{ name = "roles/${local.pubsub_custom_role}", custom = true }]
    }
  }

  ### Make 1 dimension list for each project
  pubsub_flattened_list = flatten([
    for gr, values in local.pubsub_groups : [
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
resource "google_project_iam_member" "pubsub_iam" {
  for_each = { for item in local.pubsub_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}

# Custom roles
resource "google_project_iam_custom_role" "pubsub_custom_role" {
  for_each = toset(concat(local.pubsub_pre_prod_products_projects))

  project     = each.value
  role_id     = local.pubsub_custom_role
  title       = "Custom pubusb permission to publish and subscribe"
  permissions = ["pubsub.snapshots.seek", "pubsub.subscriptions.consume", "pubsub.topics.attachSubscription", "pubsub.topics.publish"]
}
