# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "google" {
  project         = "my-deployments-2"
}

resource "google_compute_ssl_policy" "default" {
  name            = "ssl-policy"
  min_tls_version = "TLS_1_2"
  profile         = "MODERN"
}
