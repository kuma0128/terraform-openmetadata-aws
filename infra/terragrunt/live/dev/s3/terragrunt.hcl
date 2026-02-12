include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/s3"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    s3_gateway_endpoint_id = "vpce-00000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "kms_key" {
  config_path = "../kms_key"
  mock_outputs = {
    s3_kms_key_arn = "arn:aws:kms:ap-northeast-1:000000000000:key/mock-s3-key"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  name_prefix            = local.env.locals.name_prefix
  region_short_name      = local.env.locals.region_short_name
  allowed_ip_list        = local.env.locals.allowed_ip_list
  s3_gateway_endpoint_id = dependency.network.outputs.s3_gateway_endpoint_id
  s3_kms_key_arn         = dependency.kms_key.outputs.s3_kms_key_arn
}
