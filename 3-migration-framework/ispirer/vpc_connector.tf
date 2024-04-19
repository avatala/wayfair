resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
  region        = "us-central1"
  project = var.project_name
}

resource "google_compute_firewall" "allow_con" {
  name    = "allow-vpc-connector"
  network = data.google_compute_network.my_network.self_link
  project = var.project_name
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  source_ranges = ["10.8.0.0/28"]
}
