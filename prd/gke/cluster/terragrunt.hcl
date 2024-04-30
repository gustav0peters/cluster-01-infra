terraform {
  source = "tfr:///terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster?version=22.1.0"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "vpc" {
  config_path = "../../network/vpc"
}

dependency "sa" {
  config_path = "../service-account"
}

inputs = {
  project_id                 = local.common_vars.locals.project
  name                       = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-01"
  regional                   = true
  region                     = local.common_vars.locals.region
  network                    = dependency.vpc.outputs.network_name
  subnetwork                 = dependency.vpc.outputs.subnets["${local.common_vars.locals.region}/fmv3-01"]["name"]
  ip_range_pods              = "gke-pods"
  ip_range_services          = "gke-services"
  create_service_account     = false
  service_account            = dependency.sa.outputs.service_account.email
  enable_private_endpoint    = false
  enable_private_nodes       = true
  default_max_pods_per_node  = 110
  remove_default_node_pool   = true
  kubernetes_version         = "1.27.8-gke.1067004"
  monitoring_service         = "none"
  logging_enabled_components = ["SYSTEM_COMPONENTS"]
  networking_mode            = "VPC_NATIVE"

  # Addons
  gce_pd_csi_driver             = true
  config_connector              = true
  master_global_access_enabled	= false

  # Node Pools
  node_pools = [
    {
      name                = "standard-01"
      machine_type        = "e2-standard-2"
      min_count           = 1
      max_count           = 50
      local_ssd_count     = 0
      disk_size_gb        = 100
      disk_type           = "pd-standard"
      auto_repair         = true
      auto_upgrade        = true
      service_account     = dependency.sa.outputs.service_account.email
      preemptible         = false
      max_pods_per_node   = 100
      version             = "1.27.11-gke.1062000"
    }
  ]

  node_pools_labels = {
    "standard-01" = {
      "workload-type" = "standard"
    }
  }

  master_authorized_networks = [
    {
      cidr_block   = dependency.vpc.outputs.subnets["${local.common_vars.locals.region}/fmv3-01"].ip_cidr_range
      display_name = "VPC"
    },
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    },
  ]

  resource_labels = {
    "kubernetescluster" = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-1"
  }
}
