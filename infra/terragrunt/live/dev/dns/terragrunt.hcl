include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/dns"
}

inputs = {
  name_prefix           = local.env.locals.name_prefix
  region_short_name     = local.env.locals.region_short_name
  env                   = local.env.locals.env
  domain_name           = local.env.locals.domain_name
  log_retention_in_days = local.env.locals.log_retention_in_days
  dev_ns_records        = local.env.locals.dev_ns_records
  stg_ns_records        = local.env.locals.stg_ns_records
}
