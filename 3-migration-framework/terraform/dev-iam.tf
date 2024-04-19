resource "google_project_iam_member" "admin_iam" {
  project = module.migration_project.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "group:m2m-dev-wayfair@66degrees.com"
}