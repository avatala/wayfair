# workload service account
resource "google_service_account" "wisa_account" {
  account_id   = "workload-sa"
  display_name = "workload service account"
  project      = module.migration_project.project_id
}

variable "workload_roles" {
  type        = map(any)
  description = "list of roles for workloads service account"
  default = {
    pubsub_subscriber        = "roles/pubsub.subscriber"
    pubsub_publisher         = "roles/pubsub.publisher"
    pubsub_viewer            = "roles/pubsub.viewer"
    pubsub_editor            = "roles/pubsub.editor"
    storage_admin            = "roles/storage.admin"
    log_writer               = "roles/logging.logWriter"
    automl_predictor         = "roles/automl.predictor"
    gke_hub_admin            = "roles/gkehub.admin"
    secretmanager            = "roles/secretmanager.secretAccessor"
    bq_dataeditor            = "roles/bigquery.dataEditor"
    bq_user                  = "roles/bigquery.user"
    cloud_function_developer = "roles/cloudfunctions.developer"
    scheduler_job_runner     = "roles/cloudscheduler.jobRunner"
    cloud_run                = "roles/run.invoker"
    token_creator            = "roles/iam.serviceAccountTokenCreator"
    artifact_registry        = "roles/artifactregistry.admin"
    container_registry       = "roles/containerregistry.ServiceAgent"
  }
}

resource "google_project_iam_member" "workload_service_account_roles" {
  depends_on = [google_service_account.wisa_account]
  project = module.migration_project.project_id
  for_each = var.workload_roles
  role    = each.value
  member  = "serviceAccount:${google_service_account.wisa_account.email}"
}

resource "google_project_iam_member" "workload_service_account_roles_iac" {
  depends_on = [google_service_account.wisa_account]
  project = data.google_project.iac.project_id
  for_each = var.workload_roles
  role    = each.value
  member  = "serviceAccount:${google_service_account.wisa_account.email}"
}