include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/security_group"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  name_prefix       = local.env.locals.name_prefix
  region_short_name = local.env.locals.region_short_name
  allowed_ip_list   = local.env.locals.allowed_ip_list
  vpc_id            = dependency.network.outputs.vpc_id
}
