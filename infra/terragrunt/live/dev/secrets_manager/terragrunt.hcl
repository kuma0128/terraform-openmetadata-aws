include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/secrets_manager"
}

inputs = {
  name_prefix       = local.env.locals.name_prefix
  region_short_name = local.env.locals.region_short_name
}
