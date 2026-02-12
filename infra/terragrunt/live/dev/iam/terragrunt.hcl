include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/iam"
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    docker_envfile_bucket_arn = "arn:aws:s3:::mock-bucket"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  name_prefix               = local.env.locals.name_prefix
  region_short_name         = local.env.locals.region_short_name
  docker_envfile_bucket_arn = dependency.s3.outputs.docker_envfile_bucket_arn
}
