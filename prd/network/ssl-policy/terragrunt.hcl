include {
  path = find_in_parent_folders()
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

generate "ssl-policy" {
  path     = "ssl-policy.tf"
  if_exists = "overwrite"
  contents = <<-EOF
    provider "google" {
      project         = "${local.common_vars.locals.project}"
    }

    resource "google_compute_ssl_policy" "default" {
      name            = "ssl-policy"
      min_tls_version = "TLS_1_2"
      profile         = "MODERN"
    }
  EOF
}