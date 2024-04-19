terraform {
  backend "gcs" {
    bucket = "sbox-wf-pso-tf-state-bkt"
    prefix = "ispirer"
  }
}