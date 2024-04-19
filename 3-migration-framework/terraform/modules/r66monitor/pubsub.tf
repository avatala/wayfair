resource "google_pubsub_topic" "r66monitor_pubsub_topics" {
  project   = var.project_id
  for_each  = var.phase_config
  name      = each.key
}

resource "google_pubsub_subscription" "r66monitor_pubsub_bqsubs" {
  depends_on = [google_bigquery_table.pubsub_tables,google_project_iam_member.r66monitor_bqviewer, google_project_iam_member.r66monitor_bqeditor]
  project   = var.project_id
  for_each  = var.phase_config
  topic     = "projects/${var.project_id}/topics/${each.key}"
  name      = each.key
  bigquery_config {
    table = "${var.project_id}.${each.value["dataset"]}.${each.key}"
  }

  # 20 minutes
  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
      ttl = ""
  }
  retry_policy {
      minimum_backoff = "10s"
  }

}

data "google_project" "r66monitor_project" {
  project_id = var.project_id 
}

resource "google_project_iam_member" "r66monitor_bqviewer" {
  project   = var.project_id
  role   = "roles/bigquery.metadataViewer"
  member = "serviceAccount:service-${data.google_project.r66monitor_project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "r66monitor_bqeditor" {
  project   = var.project_id
  role   = "roles/bigquery.dataEditor"
  member = "serviceAccount:service-${data.google_project.r66monitor_project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}