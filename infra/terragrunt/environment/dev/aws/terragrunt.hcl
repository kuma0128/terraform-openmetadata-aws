include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Include the entire module directory so that submodules referenced using
  # relative paths are available during Terraform execution. The `//aws`
  # suffix selects the `aws` subdirectory as the entry point.
  source = "."
}

dependencies {
  paths = ["../backend"]
}

locals {
  pj_name           = "ethan"
  env               = "dev"
  region            = "ap-northeast-1"
  region_short_name = "apne1"
  repo_full_name    = "kuma0128/terraform-openmetadata-aws-assets"

  allowed_ip_list = ["" ]

  cidr_vpc             = "10.0.0.0/16"
  cidr_subnets_public  = ["10.0.0.0/24", "10.0.1.0/24"]
  cidr_subnets_private = ["10.0.10.0/24", "10.0.11.0/24"]
  az_a_name            = "ap-northeast-1a"
  az_c_name            = "ap-northeast-1c"

  domain_name            = ""
  repository_list        = ["elasticsearch", "openmetadata/server", "openmetadata/ingestion"]
  elasticsearch_tag      = "8.10.2"
  openmetadata_tag       = "1.5.3"
  ingestion_tag          = "1.5.3"
  log_retention_in_days  = 30
}

inputs = {
  pj_name              = local.pj_name
  env                  = local.env
  region               = local.region
  region_short_name    = local.region_short_name
  repo_full_name       = local.repo_full_name
  allowed_ip_list      = local.allowed_ip_list
  cidr_vpc             = local.cidr_vpc
  cidr_subnets_public  = local.cidr_subnets_public
  cidr_subnets_private = local.cidr_subnets_private
  az_a_name            = local.az_a_name
  az_c_name            = local.az_c_name
  domain_name          = local.domain_name
  repository_list      = local.repository_list
  elasticsearch_tag    = local.elasticsearch_tag
  openmetadata_tag     = local.openmetadata_tag
  ingestion_tag        = local.ingestion_tag
  log_retention_in_days = local.log_retention_in_days
}
