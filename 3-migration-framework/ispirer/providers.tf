terraform {
  required_version = ">= 0.13"
}

provider "google" {
}

provider "google-beta" {
}

data "google_client_config" "default" {}
