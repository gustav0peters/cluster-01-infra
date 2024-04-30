terraform {
  source = "tfr:///terraform-google-modules/project-factory/google//modules/project_services?version=13.0.0"
}
# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = {
  project_id    = "${local.common_vars.locals.project}"
  disable_dependent_services = true
  activate_apis = [
    "compute.googleapis.com",        # Compute Engine API
    "logging.googleapis.com",        # Cloud Logging API
    "container.googleapis.com",      # Kubernetes Engine API
    "iam.googleapis.com",            # IAM API
    "dns.googleapis.com",            # Cloud DNS API
    "cloudresourcemanager.googleapis.com",  # Cloud Resource Manager API
    "iamcredentials.googleapis.com",         # IAM Service Account Credentials API
    "cloudkms.googleapis.com"               # Cloud Key Management Service (KMS) API
  ]
}
