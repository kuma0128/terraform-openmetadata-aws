include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/environment/dev/openmetadata"
}

dependencies {
  paths = ["../dns", "../network"]
}

dependency "dns" {
  config_path = "../dns"
  mock_outputs = {
    cert_arn            = "arn:aws:acm:ap-northeast-1:000000000000:certificate/mock"
    openmetadata_zone_id = "Z111111111111"
    domain_name         = "ethan-example.com"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id               = "vpc-12345678"
    subnet_a_public_id   = "subnet-11111111"
    subnet_c_public_id   = "subnet-22222222"
    subnet_a_private_id  = "subnet-33333333"
    subnet_c_private_id  = "subnet-44444444"
    s3_gateway_endpoint_id = "vpce-111111111111"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

locals {
  pj_name           = "ethan"
  env               = "dev"
  region            = "ap-northeast-1"
  region_short_name = "apne1"
  repo_full_name    = "kuma0128/terraform-openmetadata-aws-assets"

  allowed_ip_list = ["192.0.2.0/24"]

  repository_list       = ["elasticsearch", "openmetadata/server", "openmetadata/ingestion"]
  elasticsearch_tag     = "8.10.2"
  openmetadata_tag      = "1.5.3"
  ingestion_tag         = "1.5.3"
  log_retention_in_days = 30
  backup_retention_period = 1
  instance_count          = 1
  desired_count           = 1
}

inputs = {
  pj_name               = local.pj_name
  env                   = local.env
  region                = local.region
  region_short_name     = local.region_short_name
  repo_full_name        = local.repo_full_name
  allowed_ip_list       = local.allowed_ip_list
  domain_name           = dependency.dns.outputs.domain_name
  repository_list       = local.repository_list
  elasticsearch_tag     = local.elasticsearch_tag
  openmetadata_tag      = local.openmetadata_tag
  ingestion_tag         = local.ingestion_tag
  log_retention_in_days = local.log_retention_in_days
  backup_retention_period = local.backup_retention_period
  instance_count          = local.instance_count
  desired_count           = local.desired_count
  cert_arn                = dependency.dns.outputs.cert_arn
  route53_zone_id         = dependency.dns.outputs.openmetadata_zone_id
  vpc_id                  = dependency.network.outputs.vpc_id
  subnet_a_public_id      = dependency.network.outputs.subnet_a_public_id
  subnet_c_public_id      = dependency.network.outputs.subnet_c_public_id
  subnet_a_private_id     = dependency.network.outputs.subnet_a_private_id
  subnet_c_private_id     = dependency.network.outputs.subnet_c_private_id
  s3_gateway_endpoint_id  = dependency.network.outputs.s3_gateway_endpoint_id
}
