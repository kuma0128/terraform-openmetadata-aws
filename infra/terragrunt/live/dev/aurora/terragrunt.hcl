include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/aurora"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnet_a_private_id = "subnet-00000000000000001"
    subnet_c_private_id = "subnet-00000000000000002"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "kms_key" {
  config_path = "../kms_key"
  mock_outputs = {
    aurora_kms_key_arn = "arn:aws:kms:ap-northeast-1:000000000000:key/mock-aurora-key"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "security_group" {
  config_path = "../security_group"
  mock_outputs = {
    openmetaedata_aurora_security_group_id = "sg-00000000000000001"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "secrets_manager" {
  config_path = "../secrets_manager"
  mock_outputs = {
    aurora_password = "mock-password-aurora"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  name_prefix              = local.env.locals.name_prefix
  region_short_name        = local.env.locals.region_short_name
  subnet_a_private_id      = dependency.network.outputs.subnet_a_private_id
  subnet_c_private_id      = dependency.network.outputs.subnet_c_private_id
  aurora_kms_key_arn       = dependency.kms_key.outputs.aurora_kms_key_arn
  aurora_security_group_id = dependency.security_group.outputs.openmetaedata_aurora_security_group_id
  aurora_password          = dependency.secrets_manager.outputs.aurora_password
  backup_retention_period  = local.env.locals.backup_retention_period
  instance_count           = local.env.locals.instance_count
}
