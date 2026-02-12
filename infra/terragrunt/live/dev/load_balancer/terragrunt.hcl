include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/load_balancer"
}

dependency "dns" {
  config_path = "../dns"
  mock_outputs = {
    cert_arn             = "arn:aws:acm:ap-northeast-1:000000000000:certificate/mock"
    openmetadata_zone_id = "Z111111111111"
    domain_name          = "ethan-example.com"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id             = "vpc-00000000000000000"
    subnet_a_public_id = "subnet-00000000000000001"
    subnet_c_public_id = "subnet-00000000000000002"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "security_group" {
  config_path = "../security_group"
  mock_outputs = {
    openmetadata_lb_security_group_id = "sg-00000000000000001"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  domain_name                       = dependency.dns.outputs.domain_name
  name_prefix                       = local.env.locals.name_prefix
  region_short_name                 = local.env.locals.region_short_name
  cert_arn                          = dependency.dns.outputs.cert_arn
  route53_zone_id                   = dependency.dns.outputs.openmetadata_zone_id
  vpc_id                            = dependency.network.outputs.vpc_id
  subnet_a_public_id                = dependency.network.outputs.subnet_a_public_id
  subnet_c_public_id                = dependency.network.outputs.subnet_c_public_id
  openmetadata_lb_security_group_id = dependency.security_group.outputs.openmetadata_lb_security_group_id
}
