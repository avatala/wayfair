variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in"
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in"
}


variable "ip_range_pods" {
  type        = string
  description = "The name of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The name of the secondary subnet range to use for services"
}
