terraform {
  source = "../../../../kubernetes"
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

generate "provider-local" {
  path      = "provider-local.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    data "google_client_config" "default" {}

    provider "kubernetes" {
      host                   = "https://${dependency.cluster.outputs.endpoint}"
      cluster_ca_certificate = base64decode("${dependency.cluster.outputs.ca_certificate}")
      token                  = data.google_client_config.default.access_token
    }
EOF
}

inputs = {
  manifest = templatefile("config-connector.tftpl", {
    sa_email = "${dependency.sa.outputs.email}",
  })
}
