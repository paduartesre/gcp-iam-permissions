locals {
  ### Products projects
  firebase_pre_prod_products_projects = ["contoso-development-v2", "contoso-staging-v2"]
  firebase_prod_products_projects     = ["contoso-production-v2"]
  firebase_sources_projects           = ["contoso-sources"]
  firebase_stable_projects             = ["contoso-meuid"]

  ### Custom Roles

  ### Groups and roles
  firebase_groups = {
    "group:firebase.viewers@contoso.co" = { # team.technology@contoso.co
      projects = toset(concat(local.firebase_pre_prod_products_projects, local.firebase_prod_products_projects, local.firebase_sources_projects, local.firebase_stable_projects)),
      role     = [{ name = "roles/firebase.viewer", custom = false }]
    }
    "group:firebase.hostingAdmin@contoso.co" = { # risk.alpha
      projects = toset(concat(local.firebase_pre_prod_products_projects, local.firebase_prod_products_projects)),
      role     = [{ name = "roles/firebasehosting.admin", custom = false }, { name = "roles/cloudconfig.admin", custom = false }]
    }
    "group:firebase.firestoreUser@contoso.co" = {
      projects = toset(concat(local.firebase_sources_projects)),
      role     = [{ name = "roles/datastore.user", custom = false }]
    }
  }

  ### Make 1 dimension list for each project
  firebase_flattened_list = flatten([
    for gr, values in local.firebase_groups : [
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

## firebase
# IAM Members
resource "google_project_iam_member" "firebase_iam" {
  for_each = { for item in local.firebase_flattened_list : item.key => item }

  project = each.value.project
  role    = each.value.role
  member  = each.value.group
}
