output "cluster_ca_certificate" {
  description = "Cluster ca certificate"
  value       = module.gke.ca_certificate
  sensitive = true
}

output "project_id" {
  description = "main project id"
  value       = module.migration_project.project_id
  
}