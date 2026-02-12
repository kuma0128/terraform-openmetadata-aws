include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/ecr"
}

dependency "kms_key" {
  config_path = "../kms_key"
  mock_outputs = {
    ecr_kms_key_arn = "arn:aws:kms:ap-northeast-1:000000000000:key/mock-ecr-key"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  ecr_kms_key_arn   = dependency.kms_key.outputs.ecr_kms_key_arn
  repository_list   = local.env.locals.repository_list
  elasticsearch_tag = local.env.locals.elasticsearch_tag
  openmetadata_tag  = local.env.locals.openmetadata_tag
  ingestion_tag     = local.env.locals.ingestion_tag
}
