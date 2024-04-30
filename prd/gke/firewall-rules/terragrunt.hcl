terraform {
  source = "tfr:///terraform-google-modules/network/google//modules/firewall-rules//?version=5.2.0"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "cluster" {
  config_path = "../cluster"
}

dependency "vpc" {
  config_path = "../../network/vpc"
}

dependency "sa" {
  config_path = "../service-account"
}

inputs = {
  project_id   = local.common_vars.locals.project
  network_name = dependency.vpc.outputs.network_name

  rules = [{
    name                    = "allow-gke-webhook-adminssion"
    description             = "allows gke controll plane to access pods for admission controll"
    direction               = "INGRESS"
    ranges                  = [dependency.cluster.outputs.master_ipv4_cidr_block]
    priority                = null
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = [dependency.sa.outputs.service_account.email]
    deny  = []
    allow = [{
      protocol = "tcp"
      ports    = ["6443"]
    }]
    log_config = {
      metadata = "EXCLUDE_ALL_METADATA"
    }
  },]
}
