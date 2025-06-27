include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/environment/dev/network"
}

locals {
  pj_name           = "ethan"
  env               = "dev"
  region            = "ap-northeast-1"
  region_short_name = "apne1"
  cidr_vpc             = "10.0.0.0/16"
  cidr_subnets_public  = ["10.0.0.0/24", "10.0.1.0/24"]
  cidr_subnets_private = ["10.0.10.0/24", "10.0.11.0/24"]
  az_a_name            = "ap-northeast-1a"
  az_c_name            = "ap-northeast-1c"
}

inputs = {
  pj_name              = local.pj_name
  env                  = local.env
  region               = local.region
  region_short_name    = local.region_short_name
  cidr_vpc             = local.cidr_vpc
  cidr_subnets_public  = local.cidr_subnets_public
  cidr_subnets_private = local.cidr_subnets_private
  az_a_name            = local.az_a_name
  az_c_name            = local.az_c_name
}
