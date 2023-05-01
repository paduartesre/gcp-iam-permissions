output "gcs_iam_binding" {
  description = "IAM bindings for GCS readonly groups"
  value       = module.gcs_iam.iam_binding
}

output "auditlogs_iam_binding" {
  description = "IAM bindings for audit logs readonly groups"
  value       = module.auditlogs_iam.iam_binding
}

output "gce_iam_binding" {
  description = "IAM bindings for GCE admin groups"
  value       = module.gce_iam.iam_binding
}
