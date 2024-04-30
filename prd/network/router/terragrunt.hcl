terraform {
  source = "tfr:///terraform-google-modules/cloud-router/google//?version=3.0.0"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  project = "${local.common_vars.locals.project}"
  name    = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-router-01"
  network = "${dependency.vpc.outputs.network_id}"
  region  = "${local.common_vars.locals.region}"
}
