terraform {
  source = "tfr:///terraform-google-modules/cloud-dns/google//?version=4.1.0"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = {
  project_id = local.common_vars.locals.project
  type       = "public"
  name       = local.common_vars.locals.project
  domain     = "digitalview.com.br."
}