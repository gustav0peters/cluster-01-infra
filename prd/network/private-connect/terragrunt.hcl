terraform {
  source = "tfr:///GoogleCloudPlatform/sql-db/google//modules/private_service_access?version=13.0.1"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "vpc" {
  config_path = "../../network/vpc"
}

inputs = {
  project_id    = local.common_vars.locals.project
  name          = "google-managed-services-${dependency.vpc.outputs.network_name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  vpc_network   = dependency.vpc.outputs.network_name
}
