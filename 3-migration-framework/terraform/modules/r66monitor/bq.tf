# create the datasets
resource "google_bigquery_dataset" "r66monitor_datasets" {
  for_each = toset(var.bq_datasets)
  dataset_id    = each.key
  friendly_name = each.key
  description   = each.key
  location      = var.location
  project       = var.project_id
}

resource "google_bigquery_table" "pubsub_tables" {
  depends_on  = [google_bigquery_dataset.r66monitor_datasets]
  for_each    = var.phase_config
  project     = var.project_id
  dataset_id  = each.value["dataset"]
  table_id    = each.key
  schema      = file("${each.value["schema"]}")
}
