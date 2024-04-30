# Configure Terragrunt to automatically store tfstate files in GCS bucket
locals {
  env              = "production"
  project          = "my-deployments-2"
  region           = "us-east1"
  bucket           = "terraform-state-${local.region}-${local.project}"
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
    }
  config = {
    bucket    = "${local.bucket}"
    prefix    = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
    project   = "${local.project}"
    location  = "${local.region}"
  }
}
