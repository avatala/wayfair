data "google_compute_network" "my_network" {
  name = "default"
  project = module.migration_project.project_id
}

resource "google_service_account" "sql_service_account" {
  account_id   = "sa-sql-server"
  display_name = "sa for sql server"
  project = module.migration_project.project_id
}

resource "google_project_iam_member" "sql_service_account_roles" {
  depends_on = [google_service_account.sql_service_account]
  project = module.migration_project.project_id
  for_each = var.sql_sa_roles
  role    = each.value
  member  = "serviceAccount:${google_service_account.sql_service_account.email}"
}


resource "google_compute_instance" "sql-server" {
  name         = var.vm_name
  project = module.migration_project.project_id
  zone    = var.gcp_zone
  description  = "SQL Server 2019 Standard on Windows Server 2019 Datacenter"
  machine_type = var.machine_type
  allow_stopping_for_update = true
  #tags         = ["sql-i-allow"]
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
  network_interface {
    network  = data.google_compute_network.my_network.self_link
    access_config {
      // Ephemeral public IP
    }

  }
  attached_disk {
    source = google_compute_disk.ispirer-disk.self_link
  }
  service_account {
    email  = google_service_account.sql_service_account.email
    scopes = ["cloud-platform"]
  }
}

