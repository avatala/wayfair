variable "sql_sa_roles" {
  type        = map(any)
  description = "list of roles for sql server service account"
  default = {
    basic    = "roles/owner"
  }
}

variable "disk" {
    type = string
    description = "Enter the disk name to be attached to ispirer vm"
    default = "ispirer-server-disk"
}

variable "vm_name" {
    type = string
    description = "Please provide the Isperier vm name"
    default = "ispirer-server"
}

variable gcp_zone {
  type        = string
  description = "The GCP Zone where the testing instances will reside"
  default     = "us-east1-b"
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

variable "project_name" {
  type = string
  default = "sbox-wf-pso"
}