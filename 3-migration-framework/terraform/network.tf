module "vpc" {
    # https://github.com/terraform-google-modules/terraform-google-network
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0"

    project_id   = module.migration_project.project_id
    network_name = var.network
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "us-east1-01"
            subnet_ip             = "10.127.0.0/20"
            subnet_region         = "us-east1"
            subnet_private_access = "true"
        },
        
    ]

    secondary_ranges = {
        us-east1-01 = [
            {
                range_name    = "us-east1-01-gke-01-pods"
                ip_cidr_range = "100.64.192.0/20"
            },
            {
                range_name    = "us-east1-01-gke-01-services"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]
    }

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        },
        
    ]
}