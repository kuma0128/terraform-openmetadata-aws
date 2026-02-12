include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/backend"
}

dependency "cicd" {
  config_path = "../cicd"
  mock_outputs = {
    github_actions_iam_role_id = "AROA000000000000MOCK"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  name_prefix                = local.env.locals.pj_name
  region_short_name          = local.env.locals.region_short_name
  allowed_ip_list            = local.env.locals.allowed_ip_list
  github_actions_iam_role_id = [dependency.cicd.outputs.github_actions_iam_role_id]
  allowed_vpce_ids           = []
}
