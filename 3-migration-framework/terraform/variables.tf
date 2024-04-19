variable "environment" {
  type        = string
  description = "the enviroment passed from GCB"
  default = "dev"
}

variable database_password {
  type        = string
  description = "The root db password"
}

variable billing_account {
  type        = string
  description = "The billing account id for the project getting created"
}

variable iac_project {
  type        = string
  description = "the id of the project where this code is running from - supplied by the GCB yaml and used to get the org id"
}

variable unique_name {
  type        = string
  description = "the name to use for folder and project ids"
}

variable groups_email {
  type        = list
  description = "the google groups to receive the iam perms"
  default = [""]
  
}

variable parent_folder {
  type        = string
  description = "the gcp parent folder where this migration will be created"
}


variable iam_roles {
  type        = list
  description = "list of IAM roles to grant to the group"
  default = ["roles/editor"]
}

variable gcp_region {
  type        = string
  description = "the GCP region where the VPN and SQL instance will be running"
  default     = "us-east1"
}

variable gcp_zone {
  type        = string
  description = "The GCP Zone where the testing instances will reside"
  default     = "us-east1-b"
}

variable "default_service_account" {
  type = string
  description = "creation of default service account"
  default = "keep"
}

##### VM Configuration   #####

variable "vm_name" {
    type = string
    description = "Please provide the Isperier vm name"
    default = "sql-server"
}

variable "machine_type" {
    type = string
    description = "Enter the machine type for the ispirer vm,changing it cause the recreation of the VM"
    default = "n2-standard-4"
  
}

variable "vm_image" {
    type = string
    description = "Enter the boot dik image name for the ispirer vm,changing it cause the recreation of the VM"
    default = "windows-sql-cloud/sql-2019-web-windows-2022-dc-v20221109"
  
}

variable "test_sql_vm_image" {
    type = string
    description = "Enter the boot disk image name for the test sql VM"
    default = "windows-sql-cloud/sql-2019-enterprise-windows-2019-dc-v20221215"
  
}

variable "disk" {
    type = string
    description = "Enter the disk name to be attached to ispirer vm"
    default = "sql-server-disk"
}

# variable "vpc_network" {
#     type = string
#     description = "Enter the VPC network name"
#     default = "wayfair-network"
# }

variable "sql_sa_roles" {
  type        = map(any)
  description = "list of roles for sql server service account"
  default = {
    basic    = "roles/owner"
  }
}


##### Cloud Run  ######

variable "cloud_run_name" {
  type = string
  description = "The name of the Cloud Run service to create"
  default = "data-validator"
}

# variable "tag" {
#     type= string
#     description = "commit ID"
# }

variable "striim_cloud_run_name" {
  type = string
  description = "The name of the Cloud Run service to create"
  default = "wf-striim-application"
}

variable "striim_application_url" {
  type = string
  description = "URL of the Striim application with port"
  default = "http://34.148.153.128:9080"
}
########################### GKE ############################
variable "gke_zones" {
    type = list(string)
    description = "zones list to create the nodes in"
    default = ["us-east1-b"]
}
variable "network" {
  type = string
  default = "dvt-network" 
}

variable "gke_name" {
  type = string
  description = "Cluster name"
  default = "dvt-cluster"
}








