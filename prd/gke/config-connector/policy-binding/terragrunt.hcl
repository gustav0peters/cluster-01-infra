terraform {
  source = "tfr:///terraform-google-modules/iam/google//modules/service_accounts_iam//?version=7.4.1"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "cluster" {
  config_path = "../../cluster"
}

dependency "sa" {
  config_path = "../service-account"
}

inputs = {
  project          = "${local.common_vars.locals.project}"
  mode             = "authoritative"
  service_accounts = [
    dependency.sa.outputs.email,
  ]
  bindings         = {
    "roles/iam.workloadIdentityUser" = [
      "serviceAccount:${dependency.cluster.outputs.identity_namespace}[cnrm-system/cnrm-controller-manager]",
    ]
  }
}
