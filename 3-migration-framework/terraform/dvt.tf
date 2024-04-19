
# Enables the Cloud Run API
resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  project            = module.migration_project.project_id
  disable_on_destroy = false
}


# data "google_container_registry_image" "dvt" {
#   name = "data-validation"
#   project = module.migration_project.project_id
#   tag = var.tag
# }


# # Creates the Cloud Run service
# resource "google_cloud_run_service" "run_service" {
#   name     = var.cloud_run_name
#   location = var.gcp_region
#   project = module.migration_project.project_id
  
#   template {
#     spec {
#       containers {
#         image = data.google_container_registry_image.dvt.image_url
#       }
#       service_account_name = resource.google_service_account.wisa_account.email
#     }
#   }
#   traffic {
#     percent         = 100
#     latest_revision = true
#   }

#   # Waits for the Cloud Run API to be enabled
#   depends_on = [google_project_service.run_api]
# }


# # Allows unauthenticated users to invoke the service
# resource "google_cloud_run_service_iam_member" "run_all_users" {
#   project  = var.project_id
#   service  = google_cloud_run_service.run_service.name
#   location = google_cloud_run_service.run_service.location
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }