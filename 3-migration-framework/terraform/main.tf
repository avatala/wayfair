data "google_folder" "parent" {
  folder = "folders/${var.parent_folder}"
}

data "google_project" "iac" {
  project_id = var.iac_project
}

resource "google_folder" "migration_folder" {
  display_name = var.unique_name
  parent       = data.google_folder.parent.name
  
}

module "migration_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~>13.0"
  name            = "${var.unique_name}-${var.environment}"
  org_id          = data.google_project.iac.org_id
  billing_account = var.billing_account
  folder_id       = google_folder.migration_folder.name
  default_service_account = var.default_service_account
  activate_apis = [
    "compute.googleapis.com"
    ,"sql-component.googleapis.com"
    ,"sqladmin.googleapis.com"
    ,"servicenetworking.googleapis.com"
    ,"cloudresourcemanager.googleapis.com"
    ,"appengine.googleapis.com"
    ,"cloudtasks.googleapis.com"
    ,"run.googleapis.com"
    ,"cloudscheduler.googleapis.com"
    ,"cloudbuild.googleapis.com"
    ,"artifactregistry.googleapis.com"
    ,"containerregistry.googleapis.com"
    ,"bigquery.googleapis.com"
    ,"container.googleapis.com"
    
  ]
}
# module "group_iam" {
#   source  = "./modules/project_iam"
#   iam_roles =  var.iam_roles
#   project_id = module.migration_project.project_id
#   group_email = each.key
#   for_each = toset(var.groups_email)
# }
