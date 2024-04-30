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
  names         = ["fmv3-gke-sa-01"]
  project_id    = "${local.common_vars.locals.project}"
  generate_keys = true
  project_roles = [
    "${local.common_vars.locals.project}=>roles/container.nodeServiceAccount",
  ]
  display_name  = "Service account managed by Terraform"
  description   = "Service account to manage infrastructure"
}
