terraform {
  source = "tfr:///terraform-google-modules/cloud-nat/google//?version=2.2.1"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "router" {
  config_path = "../router"
}

inputs = {
  project_id       = "${local.common_vars.locals.project}"
  name             = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-nat-01"
  region           = "${local.common_vars.locals.region}"
  router           = "${dependency.router.outputs.router.name}"

  min_ports_per_vm = 2048
}
