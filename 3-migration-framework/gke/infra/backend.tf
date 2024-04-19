terraform {
  backend "gcs" {
    bucket = "tmp-wf-iac-tfstate"
    prefix = "gke-auto/state"
  }
}