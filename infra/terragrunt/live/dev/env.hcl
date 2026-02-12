locals {
  pj_name           = "ethan"
  env               = "dev"
  region            = "ap-northeast-1"
  region_short_name = "apne1"
  name_prefix       = "${local.pj_name}-${local.env}"

  # Networking
  cidr_vpc             = "10.0.0.0/16"
  cidr_subnets_public  = ["10.0.0.0/24", "10.0.1.0/24"]
  cidr_subnets_private = ["10.0.10.0/24", "10.0.11.0/24"]
  az_a_name            = "ap-northeast-1a"
  az_c_name            = "ap-northeast-1c"

  # Security
  allowed_ip_list = ["192.0.2.0/24"]

  # DNS
  domain_name    = "ethan-example.com"
  dev_ns_records = []
  stg_ns_records = []

  # CICD
  repo_full_name = "kuma0128/terraform-openmetadata-aws-assets"

  # ECR / Container Images
  repository_list   = ["elasticsearch", "openmetadata/server", "openmetadata/ingestion"]
  elasticsearch_tag = "8.10.2"
  openmetadata_tag  = "1.5.3"
  ingestion_tag     = "1.5.3"

  # Operations
  log_retention_in_days   = 30
  backup_retention_period = 1
  instance_count          = 1
  desired_count           = 1
}
