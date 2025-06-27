include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/environment/dev/dns"
}

dependencies {
  paths = ["../backend"]
}

locals {
  pj_name           = "ethan"
  env               = "dev"
  region_short_name = "apne1"
  domain_name       = "ethan-example.com"
  log_retention_in_days = 30
  dev_ns_records    = []
  stg_ns_records    = []
}

inputs = {
  pj_name               = local.pj_name
  env                   = local.env
  region_short_name     = local.region_short_name
  domain_name           = local.domain_name
  log_retention_in_days = local.log_retention_in_days
  dev_ns_records        = local.dev_ns_records
  stg_ns_records        = local.stg_ns_records
}
