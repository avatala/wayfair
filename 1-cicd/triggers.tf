
variable iac_environment {
  type        = string
  description = "This is the environment variable for customized naming and locations - should be either dev or prod"
  default = ""
}

variable iac_project {
  type        = string
  description = "This is the environment variable for project where GCB runs"
}

variable tf_state_bucket {
  type        = string
  description = "This is the environment variable for the bucket to use for passing into terraform cloud build triggers"
}

variable repo_owner {
  type        = string
  description = "This is the environment variable for github owner config in triggers"
}

variable repo_name_infra {
  type        = string
  description = "This is the environment variable for github repo config in triggers"
}

variable repo_name_frontend {
  type        = string
  description = "This is the environment variable for github repo config in triggers"
  default = ""
}

variable repo_name_backend {
  type        = string
  description = "This is the environment variable for github repo config in triggers"
  default = ""
}


variable app_name {
  type        = string
  description = "The name of the app to use in naming triggers"
  default = ""
}

variable gcb_roles {
  type        = list
  default = ["roles/pubsub.editor"]
}

variable "cr_project_id" {
    type = string
    description = "The name of the project to hold the DVT container image"
    default = "m2m-wayfair-dev"
}
variable "run_dir" {
  type = string
  description = "cloud run container source code directory"
  default = "3-migration-framework/apps/dvt"
}

variable "run_striim_dir" {
  type = string
  description = "cloud run container source code directory"
  default = "99-tests/striim-utils/examples/API/striim_application/app"
}

locals {
    vending_terraform = {
        vending_plan = {
          name_prefix="tf-plan-vending"
          dir="2-vending-machine/terraform"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          repo_name_frontend=var.repo_name_frontend
          repo_name_backend=var.repo_name_backend
          description = "Push to ${var.iac_environment} branch with changes to Terraform files runs plan"
          included_files=["2-vending-machine/terraform/**", ""]
          filename="1-cicd/cloudbuild.plan.yaml"
          branch= "(${var.iac_environment == "prod" ? "main" : "feature"})"
          bucket=var.tf_state_bucket
            # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
          prefix="vending-${var.iac_environment}"

        }
        vending_apply = {
          name_prefix="tf-apply-vending"
          dir="2-vending-machine/terraform"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          repo_name_frontend=var.repo_name_frontend
          repo_name_backend=var.repo_name_backend
          description = "Push to ${var.iac_environment} branch runs apply"
          included_files=["2-vending-machine/terraform/**"]
          filename="1-cicd/cloudbuild.apply.yaml"
          branch="(${var.iac_environment == "prod" ? "prod" : "development"})"
          bucket=var.tf_state_bucket
            # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
          prefix="vending-${var.iac_environment}"
        }
    }
    migration_terraform = {
        migration_plan = {
          name_prefix="tf-plan-migration"
          dir="3-migration-framework/terraform"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          repo_name_frontend=var.repo_name_frontend
          repo_name_backend=var.repo_name_backend
          description = "Push to ${var.iac_environment} branch with changes to Terraform files runs plan"
          included_files=["3-migration-framework/terraform/**", "3-migration-framework/apps/dvt/**",]
          ignored_files = ["3-migration-framework/terraform/striim-application.tf"]
          filename="1-cicd/cloudbuild.migration.plan.yaml"
          branch= "(${var.iac_environment == "prod" ? "main" : "feature"})"
          bucket=var.tf_state_bucket
            # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
          prefix="migration-${var.iac_environment}"

          # hardcoded for dev env only
          unique_name="m2m-wayfair"
          parent_folder="626392335791"
          billing_account="01E780-7E5C3C-047C23"
          database_password="*jghg&*gs^("
        }
        migration_apply = {
          name_prefix="tf-apply-migration"
          dir="3-migration-framework/terraform"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          repo_name_frontend=var.repo_name_frontend
          repo_name_backend=var.repo_name_backend
          description = "Push to ${var.iac_environment} branch runs apply"
          included_files=["3-migration-framework/terraform/**","3-migration-framework/apps/dvt/**"]
          ignored_files = []
          filename="1-cicd/cloudbuild.migration.apply.yaml"
          branch="(${var.iac_environment == "prod" ? "prod" : "development"})"
          bucket=var.tf_state_bucket
            # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
          prefix="migration-${var.iac_environment}"

          # hardcoded for dev env only
          unique_name="m2m-wayfair"
          parent_folder="626392335791"
          billing_account="01E780-7E5C3C-047C23"
          database_password="*jghg&*gs^("
        }
        program_reporting_plan = {
          name_prefix="tf-plan-program-reporting"
          dir="4-program-reporting"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          repo_name_frontend=var.repo_name_frontend
          repo_name_backend=var.repo_name_backend
          description = "Push to ${var.iac_environment} branch with changes to Terraform files runs plan"
          included_files=["4-program-reporting/**",]
          ignored_files = []
          filename="1-cicd/cloudbuild.programreporting.plan.yaml"
          branch= "(${var.iac_environment == "prod" ? "main" : "feature"})"
          bucket=var.tf_state_bucket
            # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
          prefix="programreporting-${var.iac_environment}"

          # hardcoded for dev env only
          unique_name="m2m-wayfair"
          parent_folder="626392335791"
          billing_account="01E780-7E5C3C-047C23"
          database_password="*jghg&*gs^("
        }
        program_reporting_apply = {
          name_prefix="tf-apply-program-reporting"
          dir="4-program-reporting"
          repo_owner=var.repo_owner
          repo_name_infra=var.repo_name_infra
          repo_name_frontend=var.repo_name_frontend
          repo_name_backend=var.repo_name_backend
          description = "Push to ${var.iac_environment} branch runs apply"
          included_files=["4-program-reporting/**",]
          ignored_files = []
          filename="1-cicd/cloudbuild.programreporting.apply.yaml"
          branch="(${var.iac_environment == "prod" ? "prod" : "development"})"
          bucket=var.tf_state_bucket
            # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
          prefix="programreporting-${var.iac_environment}"

          # hardcoded for dev env only
          unique_name="m2m-wayfair"
          parent_folder="626392335791"
          billing_account="01E780-7E5C3C-047C23"
          database_password="*jghg&*gs^("
        }

    #     striim-app = {
    #       name_prefix="tf-apply-striim-run"
    #       dir="3-migration-framework/terraform"
    #       run_dir=var.run_dir
    #       repo_owner=var.repo_owner
    #       repo_name_infra=var.repo_name_infra
    #       repo_name_frontend=var.repo_name_frontend
    #       repo_name_backend=var.repo_name_backend
    #       description = "Push to ${var.iac_environment} branch runs apply"
    #       included_files=["3-migration-framework/terraform/striim-application.tf","99-tests/striim-utils/examples/API/striim_application/app/"]
    #       ignored_files = []
    #       filename="1-cicd/cloudbuild.striim.apply.yaml"
    #       branch="(${var.iac_environment == "prod" ? "prod" : "development"})"
    #       bucket=var.tf_state_bucket
    #         # state for tf will be stored in state-[env] folder in bucket - this is redundant when separate buckets are used for different environment state but facilitates using one bucket for all environments separated by env folder    
    #       prefix="migration-${var.iac_environment}"
    #       # hardcoded for dev env only
    #       unique_name="m2m-wayfair"
    #       parent_folder="626392335791"
    #       billing_account="01E780-7E5C3C-047C23"
    #       database_password="*jghg&*gs^("
    #       cr_project_id = var.cr_project_id
    #     }
    }
    k8s = {
        permstesting = {
          name_prefix="k8s-permstest"
          apps_dir_prefix="3-migration-framework/apps"
          repo_owner=var.repo_owner
          # using single infra repo for everything
          repo_name_frontend=var.repo_name_infra
          description = "Push to ${var.iac_environment} branch with changes to app files runs deploy"
          included_files=["3-migration-framework/apps/permstesting/**"]
          ignored_files = []
          filename="1-cicd/cloudbuild.gke.permstesting.yaml"
          # hardcoded feature branch for now
          # branch= "(${var.iac_environment == "prod" ? "prod" : "development"})"
          branch= "(${var.iac_environment == "prod" ? "prod" : "feature-permstest"})"

          # hardcoded for dev env only
          app_suffix = "permstesting"
          app_dir = "permstesting"
          namespace="default"
          # hardcoded project ids for deployment
          deploy_project="${var.iac_environment == "prod" ? "m2m-wayfair-prod" : "m2m-wayfair-dev"}" 
          cluster = "dvt-cluster"
          zone = "us-east1"
        }
    }
    cicd_pubsub = {
        migration_create = {
          name_prefix="migration-create"
          dir="3-migration-framework/terraform"
          repo_owner=var.repo_owner
          repo_name=var.repo_name_infra
          description = "Pubsub triggers creation of gcp resources"
          filename="1-cicd/cloudbuild.migration.pubsub.yaml"
          branch= "${var.iac_environment == "prod" ? "main" : "development"}"
          bucket=var.tf_state_bucket
          prefix="migration-${var.iac_environment}"
        }
        migration_delete = {
          name_prefix="migration-delete"
          dir="3-migration-framework/terraform"
          repo_owner=var.repo_owner
          repo_name=var.repo_name_infra
          description = "Pubsub triggers creation of gcp resources"
          filename="1-cicd/cloudbuild.pubsub.destroy.yaml"
          branch= "${var.iac_environment == "prod" ? "main" : "development"}"
          bucket=var.tf_state_bucket
          prefix="migration-${var.iac_environment}"
        }
    }
}


#######################
# TF TRIGGERS
resource "google_cloudbuild_trigger" "vending_triggers" {
    for_each = local.vending_terraform
    name = "${each.value["name_prefix"]}-${var.iac_environment}"
    project = var.iac_project
    description = each.value["description"]
    github { 
        owner = each.value["repo_owner"]
        name = each.value["repo_name_infra"]
        push {
            branch = each.value["branch"]
        }
    }
    # NOTE - THIS SUBST CODE MAY NEED CUSTOMIZATIONS FOR DIFFERENT INPUTS TO TF IF NEEDED
    substitutions = {
    _TF_BUCKET = each.value["bucket"]
    _TF_PREFIX = each.value["prefix"]
    _ENV_NAME = var.iac_environment
    _TF_DIR = each.value["dir"]
    }
    included_files = each.value["included_files"]
    filename = each.value["filename"]
}

resource "google_cloudbuild_trigger" "migration_triggers" {
    for_each = local.migration_terraform
    name = "${each.value["name_prefix"]}-${var.iac_environment}"
    project = var.iac_project
    description = each.value["description"]
    github { 
        owner = each.value["repo_owner"]
        name = each.value["repo_name_infra"]
        push {
            branch = each.value["branch"]
        }
    }
    # NOTE - THIS SUBST CODE MAY NEED CUSTOMIZATIONS FOR DIFFERENT INPUTS TO TF IF NEEDED
    substitutions = {
    _TF_BUCKET = each.value["bucket"]
    _TF_PREFIX = each.value["prefix"]
    _ENV_NAME = var.iac_environment
    _TF_VAR_UNIQUE_NAME = each.value["unique_name"]
    _TF_VAR_PARENT_FOLDER = each.value["parent_folder"]
    _TF_VAR_BILLING_ACCOUNT = each.value["billing_account"]
    _TF_VAR_DATABASE_PASSWORD = each.value["database_password"]
    _TF_DIR = each.value["dir"]
    _CR_PROJECT_ID = var.cr_project_id
    _TF_RUN_DIR = var.run_dir
    _TF_RUN_STRIIM_DIR = var.run_striim_dir
    }
    included_files = each.value["included_files"]
    ignored_files = each.value["ignored_files"]
    filename = each.value["filename"]
}

#######################
# PUBSUB TRIGGER
data "google_project" "gcb_project" {
    project_id = var.iac_project
}

resource "google_project_iam_member" "gcb_roles" {
  project = var.iac_project
  for_each = toset(var.gcb_roles)
  role   = each.key
  member  = "serviceAccount:${data.google_project.gcb_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_pubsub_topic" "pubsub_gcb_trigger" {
    depends_on = [google_project_iam_member.gcb_roles]
    name = "${each.value["name_prefix"]}-${var.iac_environment}"
    project = var.iac_project
    for_each = local.cicd_pubsub
}

resource "google_cloudbuild_trigger" "pubsub_triggers" {
    depends_on = [google_pubsub_topic.pubsub_gcb_trigger]
    for_each = local.cicd_pubsub
    name = "${each.value["name_prefix"]}-${var.iac_environment}"
    project = var.iac_project
    description = each.value["description"]
    
    pubsub_config {
        topic = google_pubsub_topic.pubsub_gcb_trigger[each.key].id
    }

    source_to_build {
        uri       = "https://github.com/${each.value["repo_owner"]}/${each.value["repo_name"]}"
        ref         = "refs/heads/${each.value["branch"]}"
        repo_type = "GITHUB"
    }
    
    git_file_source {
        path      = each.value["filename"]
        uri       = "https://github.com/${each.value["repo_owner"]}/${each.value["repo_name"]}"
        revision  = "refs/heads/${each.value["branch"]}"
        repo_type = "GITHUB"
    }
    
    # NOTE - THIS SUBST CODE MAY NEED CUSTOMIZATIONS FOR DIFFERENT INPUTS TO TF IF NEEDED
    substitutions = {
    _TF_VAR_UNIQUE_NAME= "$(body.message.data._TF_VAR_UNIQUE_NAME)"
    _TF_VAR_GROUP_EMAIL= "$(body.message.data._TF_VAR_GROUP_EMAIL)"
    _TF_VAR_PARENT_FOLDER= "$(body.message.data._TF_VAR_PARENT_FOLDER)"
    _TF_VAR_SERVICES= "$(body.message.data._TF_VAR_SERVICES)"
    _TF_VAR_BILLING_ACCOUNT= "$(body.message.data._TF_VAR_BILLING_ACCOUNT)"
    _TF_VAR_IAM_ROLES= "$(body.message.data._TF_VAR_IAM_ROLES)"
    _ENV_NAME = var.iac_environment
    _TF_BUCKET = each.value["bucket"]
    _TF_PREFIX = each.value["prefix"]
    _TF_DIR = each.value["dir"]
    }
}


#######################
# k8s TRIGGERS

resource "google_cloudbuild_trigger" "k8s_triggers" {
    for_each = local.k8s
    name = "${each.value["name_prefix"]}-${var.iac_environment}"
    project = var.iac_project
    description = each.value["description"]
    github { 
        owner = each.value["repo_owner"]
        name = each.value["repo_name_frontend"]
        push {
            branch = each.value["branch"]
        }
    }
    # NOTE - THIS SUBST CODE MAY NEED CUSTOMIZATIONS FOR DIFFERENT INPUTS TO TF IF NEEDED
    substitutions = {
    _ENV_NAME = var.iac_environment
    _NAMESPACE = each.value["namespace"]
    _APP_NAME = each.value["app_suffix"]
    _APP_DIR = each.value["app_dir"]
    _DIR_PREFIX = each.value["apps_dir_prefix"]
    _CONTAINER_PROJECT = var.iac_project
    _CLUSTER = each.value["cluster"]
    _ZONE = each.value["zone"]
    _DEPLOY_PROJECT = each.value["deploy_project"]
    
    }
    filename = each.value["filename"]
    included_files = each.value["included_files"]
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
