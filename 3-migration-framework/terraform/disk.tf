# Create a sql server disk

resource "google_compute_disk" "ispirer-disk" {
  name                      = var.disk
  project                   = module.migration_project.project_id
  zone                      = var.gcp_zone
  type                      = "pd-ssd"
  size                      = 50
  physical_block_size_bytes = 4096
}

resource "google_compute_disk" "test-sql-disk" {
  name                      = "test-sql-disk"
  project                   = module.migration_project.project_id
  zone                      = var.gcp_zone
  type                      = "pd-ssd"
  size                      = 2050
  physical_block_size_bytes = 4096
}

# # attach snapshot schedule policy for ispirer server disk
# resource "google_compute_disk_resource_policy_attachment" "resource-attachment" {
#   name = google_compute_resource_policy.sql-policy.name
#   disk = google_compute_disk.ispirer-disk.name
#   zone = var.zone
# }

# # Create a snapshot schedule policy for ispirer server disk

# resource "google_compute_resource_policy" "sql-policy" {
#   name   = "sql-server-prelude-disk-snapshot-schedule"
#   region = var.snapshot_region
#   snapshot_schedule_policy {
#     schedule {
#       daily_schedule {
#         days_in_cycle = 1
#         start_time    = "04:00"
#       }
#     }
#     retention_policy {
#       max_retention_days    = 10
#       on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
#     }
#   }
# }
