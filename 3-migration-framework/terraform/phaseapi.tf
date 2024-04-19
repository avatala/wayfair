locals {
  r66monitor_services = ["bigquery.googleapis.com","bigquerystorage.googleapis.com","bigquerydatatransfer.googleapis.com", "pubsub.googleapis.com" ]
  
}

resource "google_project_service" "r66monitor_services" {
  for_each = toset(local.r66monitor_services)
  project = module.migration_project.project_id
  service = each.value
  disable_dependent_services = true
}


module "r66monitor" {
  depends_on = [google_project_service.r66monitor_services]
  source      = "./modules/r66monitor"
  project_id  = module.migration_project.project_id

}