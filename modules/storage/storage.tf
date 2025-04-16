locals {
  ### Products projects
  storage_pre_prod_products_projects = ["contoso-development", "contoso-development-v2", "contoso-staging-v2", "contoso-stage"]
  storage_prod_products_projects     = ["contoso-production", "contoso-production-v2"]

  ### Custom Roles
  storage_custom_role = "contosoStorageViewers"

  ### Groups and roles
  storage_groups = {
    "group:storage.viewers@contoso.co" = {
      projects = toset(concat(local.storage_pre_prod_products_projects)),
      role = [
        { name = "roles/${local.storage_custom_role}", custom = true },
        { name = "roles/storage.objectViewer", custom = false }
      ]
    }
    "group:storage.YBR.objectViewer@contoso.co" = {
      projects = toset(["contoso-production"]),
      role = [
        { name = "roles/${local.storage_custom_role}", custom = true }
      ]
    }
  }

  storage_per_buckets_groups = {
    "group:storage.xpto.objectViewer@contoso.co" = {
      buckets = toset(["contoso-test"])
      role    = "roles/storage.objectViewer"
    }
    "group:storage.xpto.objectAdmin@contoso.co" = {
      buckets = toset(["contoso-xpto-images", "contoso-staging-xpto-service"])
      role    = "roles/storage.objectAdmin"
    }
  }

  ### Make 1 dimension list for each project
  storage_flattened_list = flatten([
    for gr, values in local.storage_groups : [
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

  ### Make 1 dimension list for each bucket
  storage_per_buckets_flattened_list = flatten([
    for gr, values in local.storage_per_buckets_groups : [
      for bk in values.buckets : {
        key       = "${gr}-${bk}-${values.role}"
        bucket    = bk
        group     = gr
        role      = values.role
        condition = can(values.condition) ? values.condition : null
        custom    = can(values.custom) ? values.custom : false
      }
    ]
  ])
}

## Storage (GCS)
# IAM Members
resource "google_project_iam_member" "storage_iam" {
  for_each = { for item in local.storage_flattened_list : item.key => item }

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

resource "google_storage_bucket_iam_member" "storage_bucket_iam" {
  for_each = { for item in local.storage_per_buckets_flattened_list : item.key => item }

  bucket = each.value.bucket
  role   = each.value.custom == true ? "projects/${each.value.project}/${each.value.role}" : each.value.role
  member = each.value.group
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      title      = condition.value.title
      expression = condition.value.expression
    }
  }
}

# Custom roles
resource "google_project_iam_custom_role" "storage_custom_role" {
  for_each = toset(concat(local.storage_pre_prod_products_projects, local.storage_prod_products_projects))

  project     = each.value
  role_id     = local.storage_custom_role
  title       = "Low level permission for Storage - PoLP"
  permissions = ["storage.buckets.list", "storage.objects.list"]
}
