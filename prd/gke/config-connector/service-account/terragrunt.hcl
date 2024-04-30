terraform {
  source = "tfr:///terraform-google-modules/service-accounts/google//?version=4.1.1"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  names         = ["config-connector"]
  project_id    = "${local.common_vars.locals.project}"
  generate_keys = false
  project_roles = [
    "${local.common_vars.locals.project}=>roles/owner"
  ]
  display_name  = "GKE Config Connector"
  description   = "SA used by GKE Config Connector"
}
