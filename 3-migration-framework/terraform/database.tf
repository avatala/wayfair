variable database_flags {
  type = list
  description = "hack to get module working with iam"
  default = [{
      name = "cloudsql.iam_authentication"
      value = "on"
    }]
}

# db service account
resource "google_service_account" "dbsa_account_test" {
  account_id   = "dbsa-testadriana"
  display_name = "dbsa-testadriana"
  project      = module.migration_project.project_id
}

module "postgresql-db" {
  # https://github.com/terraform-google-modules/terraform-google-sql-db/tree/v15.1.0/modules/postgresql
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~>10"

  name                 = "${var.unique_name}-${var.environment}"
  random_instance_name = true
  database_version     = "POSTGRES_14"
  project_id           = module.migration_project.project_id
  zone                 = var.gcp_zone
  region               = var.gcp_region
  # tier                 = "db-f1-micro"
  tier                 = "db-custom-2-4096"

  deletion_protection = false

  user_name     = "migration"
  user_password = var.database_password

  database_flags = var.database_flags

  ip_configuration = {
    ipv4_enabled       = true
    private_network    = null
    require_ssl        = false
    allocated_ip_range = null
    authorized_networks = [
        {
            name = "kaoushik"
            value = "152.58.158.24/32"
        },
        {
            name = "arun"
            value = "61.3.236.140/32"
        }
    ]
  }


}

module "postgresql-db-iam" {
  depends_on = [google_service_account.dbsa_account_test]
  # https://github.com/terraform-google-modules/terraform-google-sql-db/tree/v15.1.0/modules/postgresql
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~>15.1"

  name                 = "${var.unique_name}-${var.environment}"
  random_instance_name = false
  database_version     = "POSTGRES_14"
  project_id           = module.migration_project.project_id
  zone                 = var.gcp_zone
  region               = var.gcp_region
  # tier                 = "db-f1-micro"
  tier                 = "db-custom-2-4096"

  deletion_protection = false

  user_name     = "migration"
  user_password = var.database_password

  database_flags = var.database_flags

  ip_configuration = {
    ipv4_enabled       = true
    private_network    = null
    require_ssl        = false
    allocated_ip_range = null
    authorized_networks = [
        {
            name = "kaoushik"
            value = "152.58.158.24/32"
        },
        {
            name = "arun"
            value = "61.3.236.140/32"
        }
    ]
  }
  iam_users = [
    {
      id = google_service_account.dbsa_account_test.account_id,
      email = google_service_account.dbsa_account_test.email
    }
  ]

}
