variable "tf_state_bucket" {
  type        = string
  description = "This is the environment variable for the bucket to use for passing into terraform cloud build triggers"
}
variable "tf_state_prefix" {
  type        = string
  description = "This is the environment variable for the prefix folder for state "
}

variable "iac_project" {
  type        = string
  description = "This is the environment variable for project where GCB runs"
}
variable "repo_owner" {
  type        = string
  description = "This is the environment variable for github owner config in triggers"
}

variable "repo_name_infra" {
  type        = string
  description = "This is the environment variable for github repo config in triggers"
}


locals {
    manual_trigger = {
        bootstrap = {
          name_prefix="tf-cicd-bootstrap"
          dir="0-bootstrap"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          description = "Manual trigger to run bootstrap trigger (this file)"
          filename="0-bootstrap/bootstrap_gcb.yaml"
          bucket=var.tf_state_bucket
          prefix="bootstrap"
        }
        cicd = {
          name_prefix="tf-cicd"
          dir="1-cicd"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          description = "Manual trigger to apply cicd terraform changes"
          filename="1-cicd/cloudbuild.cicd.yaml"
          bucket=var.tf_state_bucket
          prefix="cicd"
        }
    }
}
    

#  handle updates to the prod cicd trigger earlier than prod merges by running the trigger manually in the console with the environment variable set. first run comes from bootstrap_cicd.sh with remote state to manage
# the trigger that runs this code itself, abstracted out to separate structure to pass in the repo info needed in the subsequent trigger definitions but not necessarily in their build defintions
resource "google_cloudbuild_trigger" "manual_trigger" {
    for_each = local.manual_trigger
    name = "${each.value["name_prefix"]}"
    project = var.iac_project
    description = each.value["description"]

    source_to_build {
      uri       = "https://github.com/${each.value["repo_owner"]}/${each.value["repo_name_infra"]}"
      ref       = "refs/heads/development"
      repo_type = "GITHUB"
    }
  
    git_file_source {
      path      = each.value["filename"]
      uri       = "https://github.com/${each.value["repo_owner"]}/${each.value["repo_name_infra"]}"
      revision  = "refs/heads/development"
      repo_type = "GITHUB"
    }    
    
    
    substitutions = {
    _TF_BUCKET = each.value["bucket"]
    _TF_RELATIVE_DIR = each.value["dir"]
    _TF_REPO_OWNER = each.value["repo_owner"]
    _TF_REPO_NAME_INFRA = each.value["repo_name_infra"]
    _TF_BUCKET = each.value["bucket"]
    }
}

terraform {
  backend "gcs" {
  }
}

terraform {
  required_version = ">= 0.13"
}

provider "google" {
    scopes = ["https://www.googleapis.com/auth/drive", "https://www.googleapis.com/auth/bigquery"]
    
}

provider "google-beta" {
    scopes = ["https://www.googleapis.com/auth/drive", "https://www.googleapis.com/auth/bigquery"]
    
}