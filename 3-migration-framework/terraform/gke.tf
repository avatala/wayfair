module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  project_id                 = module.migration_project.project_id
  name                       = var.gke_name
  region                     = var.gcp_region
  zones                      = var.gke_zones
  network                    = module.vpc.network_name
  subnetwork                 = "us-east1-01"
  ip_range_pods              = "us-east1-01-gke-01-pods"
  ip_range_services          = "us-east1-01-gke-01-services"
  remove_default_node_pool   = false
  http_load_balancing        = true
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  istio                      = false
  cloudrun                   = false
  dns_cache                  = false

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-medium"
      node_locations            = "us-east1-b"
      min_count                 = 1
      max_count                 = 10
      local_ssd_count           = 0
      spot                      = false
      local_ssd_ephemeral_count = 0
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      service_account           = resource.google_service_account.wisa_account.email
      preemptible               = false
      initial_node_count        = 1
    },
  ]

   node_pools_oauth_scopes = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  


  master_authorized_networks =  [ 
    {
      cidr_block = "10.10.10.0/24"
      display_name = "Subnet_access"
    },
    {
      cidr_block   = "35.235.240.0/20"
      display_name = "Google IAP access"
    }
  ]
}

module "k8s-workload-identity" {
  depends_on          = [module.gke]
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_gcp_sa = true
  gcp_sa_name         = resource.google_service_account.wisa_account.email
  name                = "workload-identity-ksa"
  project_id          = module.migration_project.project_id
  cluster_name        = var.gke_name
  namespace           = "default"
}

