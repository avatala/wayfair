
# Enables the Cloud Run API
resource "google_project_service" "striim_run_api" {
  service            = "run.googleapis.com"
  project            = module.migration_project.project_id
  disable_on_destroy = true
}


data "google_container_registry_image" "striim-application" {
  name = "striim-application"
  project = module.migration_project.project_id
  tag = "latest"
}


# Creates the Cloud Run service
resource "google_cloud_run_service" "striim_cloud_run" {
  name     = var.striim_cloud_run_name
  location = var.gcp_region
  project = module.migration_project.project_id
  
  template {
    spec {
      containers {
        image = data.google_container_registry_image.striim-application.image_url

        env {
          name = "PROJECT_ID"
          value = module.migration_project.project_id
        }
        env {
          name = "STRIIM_URL"
          value = var.striim_application_url
        }
      }
      service_account_name = resource.google_service_account.wisa_account.email
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

  # Waits for the Cloud Run API to be enabled
  depends_on = [google_project_service.striim_run_api]
}
