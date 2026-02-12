include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/network"
}

inputs = {
  name_prefix          = local.env.locals.name_prefix
  region               = local.env.locals.region
  region_short_name    = local.env.locals.region_short_name
  az_a_name            = local.env.locals.az_a_name
  az_c_name            = local.env.locals.az_c_name
  cidr_vpc             = local.env.locals.cidr_vpc
  cidr_subnets_public  = local.env.locals.cidr_subnets_public
  cidr_subnets_private = local.env.locals.cidr_subnets_private
}
