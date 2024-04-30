terraform {
  source = "tfr:///terraform-google-modules/kms/google//?version=2.2.0"
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
	location   = "global"
	keyring    = "deployments-${local.common_vars.locals.env}"
	keys       = ["ksops-encryption-key-${local.common_vars.locals.env}"]
}
