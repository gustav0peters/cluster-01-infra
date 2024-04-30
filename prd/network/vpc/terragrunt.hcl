terraform {
  source = "tfr:///terraform-google-modules/network/google//?version=5.1.0"
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
  project_id       = "${local.common_vars.locals.project}"
  network_name     = "deployments-${local.common_vars.locals.env}"

  description      = "VPC"
  routing_mode     = "REGIONAL"

  subnets          = [
    {
      subnet_name           = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-01"
      subnet_ip             = "10.7.0.0/20"
      subnet_region         = "${local.common_vars.locals.region}"
      subnet_private_access = true
    },
    {
      subnet_name           = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-02"
      subnet_ip             = "10.7.16.0/20"
      subnet_region         = "${local.common_vars.locals.region}"
      subnet_private_access = true
    },
    {
      subnet_name           = "fmv3-01"
      subnet_ip             = "10.10.0.0/20"
      subnet_region         = "${local.common_vars.locals.region}"
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-01" = [
      {
        range_name    = "public-services",
        ip_cidr_range = "10.8.0.0/20"
      },
      {
        range_name    = "gke-deployments-dev-us-east1-services-5e75994d",
        ip_cidr_range = "10.158.96.0/20"
      }
    ],
    "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-02" = [
      {
        range_name    = "private-services"
        ip_cidr_range = "10.8.16.0/20"
      },
    ],
    "fmv3-01" = [
      {
        range_name    = "gke-pods"
        ip_cidr_range = "10.10.16.0/20"
      },
      {
        range_name    = "gke-services"
        ip_cidr_range = "10.11.0.0/20"
      },
    ],
  }

  firewall_rules   = [
    {
      name              = "deployments-${local.common_vars.locals.env}-${local.common_vars.locals.region}-allow-restricted-inbound-01"
      direction         = "INGRESS"
      destination_rages = []
      source_tags       = [
        "private",
        "private-persistence"
      ]
      target_tags       = [
        "private-persistence"
      ]
      allow             = [
        {
          protocol = "all"
          ports    = []
        }
      ]
    }
  ]
}
