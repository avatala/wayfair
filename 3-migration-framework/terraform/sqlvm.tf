resource "google_service_account" "test_sql_service_account" {
  account_id   = "test-sa-sql-server"
  display_name = "test sa for sql server"
  project = module.migration_project.project_id
}

resource "google_project_iam_member" "test_sql_service_account_roles" {
  depends_on = [google_service_account.test_sql_service_account]
  project = module.migration_project.project_id
  for_each = var.sql_sa_roles
  role    = each.value
  member  = "serviceAccount:${google_service_account.test_sql_service_account.email}"
}

# This created a text file successfully
# data "template_file" "windows-metadata" {
# template = <<EOF
# New-Item C:\test.txt
# Set-Content C:\test.txt 'It worked!'
# EOF
# }

data "template_file" "windows-metadata" {
template = <<EOF
Install-PackageProvider -Name NuGet -force
Install-Module -Name "dbatools" -force
New-DbaDatabase -SqlInstance "TEST-SQL-SERVER" -Name "TPCC" -DataFilePath "d:\data" -LogFilePath "d:\data" -LogSize "65000" -LogMaxSize "65000" -PrimaryFileSize "190000" -PrimaryFileMaxSize "1000000" -PrimaryFileGrowth "64" -LogFileSuffix "_log"
Set-DbaDbCompatibility -SqlInstance test-sql-server -Database TPCC -Compatibility Version110
Set-DbaDbRecoveryModel -SqlInstance test-sql-server -Database TPCC -RecoveryModel Simple -Confirm:$false
EOF
}

resource "google_compute_instance" "test-sql-server" {
  name         = "test-sql-server"
  project = module.migration_project.project_id
  zone    = var.gcp_zone
  description  = "SQL Server 2019 Standard on Windows Server 2019 Datacenter"
  machine_type = var.machine_type
  metadata = {
    windows-startup-script-ps1 = data.template_file.windows-metadata.rendered
  }    
 
  boot_disk {
    initialize_params {
      image = var.test_sql_vm_image
    }
  }
  network_interface {
    network  = data.google_compute_network.my_network.self_link
    access_config {
      // Ephemeral public IP
    }

  }
  attached_disk {
    source = google_compute_disk.test-sql-disk.self_link
  }
  service_account {
    email  = google_service_account.test_sql_service_account.email
    scopes = ["cloud-platform"]
  }
}

