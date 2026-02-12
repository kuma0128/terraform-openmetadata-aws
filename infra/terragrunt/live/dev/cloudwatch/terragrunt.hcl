include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/cloudwatch"
}

inputs = {
  log_retention_in_days = local.env.locals.log_retention_in_days
}
