resource "google_project_iam_binding" "project" {
  project = var.project
  role    = var.role

  members = [for group in var.members : "group:${group}"]
}
