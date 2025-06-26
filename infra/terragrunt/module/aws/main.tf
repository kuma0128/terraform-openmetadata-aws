terraform {
  backend "s3" {}
}

module "iam_github_oidc" {
  source            = "../module/cicd/iam_github_oidc"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
  repo_full_name    = var.repo_full_name
}

module "network" {
  source               = "../module/aws/network"
  name_prefix          = "${var.pj_name}-${var.env}"
  region               = var.region
  region_short_name    = var.region_short_name
  az_a_name            = var.az_a_name
  az_c_name            = var.az_c_name
  cidr_vpc             = var.cidr_vpc
  cidr_subnets_public  = var.cidr_subnets_public
  cidr_subnets_private = var.cidr_subnets_private
}

module "openmetadata_kms_key" {
  source            = "../module/aws/openmetadata/kms_key"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
}

module "openmetadata_s3" {
  source                 = "../module/aws/openmetadata/s3"
  name_prefix            = "${var.pj_name}-${var.env}"
  region_short_name      = var.region_short_name
  allowed_ip_list        = var.allowed_ip_list
  s3_gateway_endpoint_id = module.network.s3_gateway_endpoint_id
  s3_kms_key_arn         = module.openmetadata_kms_key.s3_kms_key_arn
}

module "openmetadata_iam" {
  source                    = "../module/aws/openmetadata/iam"
  name_prefix               = "${var.pj_name}-${var.env}"
  region_short_name         = var.region_short_name
  docker_envfile_bucket_arn = module.openmetadata_s3.docker_envfile_bucket_arn
}

module "openmetadata_security_group" {
  source            = "../module/aws/openmetadata/security_group"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
  allowed_ip_list   = var.allowed_ip_list
  vpc_id            = module.network.vpc_id
}

module "openmetadata_secretmanager" {
  source            = "../module/aws/openmetadata/secrets_manager"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
}

module "openmetadata_cloudwatch" {
  source                = "../module/aws/openmetadata/cloudwatch"
  log_retention_in_days = var.log_retention_in_days
}

module "openmetadata_aurora" {
  source                   = "../module/aws/openmetadata/aurora"
  name_prefix              = "${var.pj_name}-${var.env}"
  region_short_name        = var.region_short_name
  subnet_a_private_id      = module.network.subnet_a_private_id
  subnet_c_private_id      = module.network.subnet_c_private_id
  aurora_kms_key_arn       = module.openmetadata_kms_key.aurora_kms_key_arn
  aurora_security_group_id = module.openmetadata_security_group.openmetaedata_aurora_security_group_id
  aurora_secret_name       = module.openmetadata_secretmanager.aurora_secret_name
}

module "openmetadata_ecr" {
  source            = "../module/aws/openmetadata/ecr"
  allowed_ip_list   = var.allowed_ip_list
  vpc_id            = module.network.vpc_id
  ecr_kms_key_arn   = module.openmetadata_kms_key.ecr_kms_key_arn
  repository_list   = var.repository_list
  elasticsearch_tag = var.elasticsearch_tag
  openmetadata_tag  = var.openmetadata_tag
  ingestion_tag     = var.ingestion_tag
}

module "openmetadata_lb" {
  source                            = "../module/aws/openmetadata/load_balancer"
  domain_name                       = var.domain_name
  name_prefix                       = "${var.pj_name}-${var.env}"
  region_short_name                 = var.region_short_name
  vpc_id                            = module.network.vpc_id
  subnet_a_public_id                = module.network.subnet_a_public_id
  subnet_c_public_id                = module.network.subnet_c_public_id
  openmetadata_lb_security_group_id = module.openmetadata_security_group.openmetadata_lb_security_group_id
}

module "openmetadata_ecs" {
  source                              = "../module/aws/openmetadata/ecs"
  region                              = var.region
  region_short_name                   = var.region_short_name
  name_prefix                         = "${var.pj_name}-${var.env}"
  subnet_a_private_id                 = module.network.subnet_a_private_id
  subnet_c_private_id                 = module.network.subnet_c_private_id
  domain_name                         = var.domain_name
  elasticsearch_tag                   = var.elasticsearch_tag
  openmetadata_tag                    = var.openmetadata_tag
  ingestion_tag                       = var.ingestion_tag
  ecs_task_role_arn                   = module.openmetadata_iam.ecs_task_role_arn
  ecs_task_execution_role_arn         = module.openmetadata_iam.ecs_task_execution_role_arn
  openmetadata_secret_name            = module.openmetadata_secretmanager.openmetadata_secret_name
  aurora_cluster_endpoint             = module.openmetadata_aurora.aurora_cluster_endpoint
  docker_envfile_bucket_arn           = module.openmetadata_s3.docker_envfile_bucket_arn
  elastic_search_log_group_name       = module.openmetadata_cloudwatch.elastic_search_log_group_name
  migrate_all_log_group_name          = module.openmetadata_cloudwatch.migrate_all_log_group_name
  openmetadata_server_log_group_name  = module.openmetadata_cloudwatch.openmetadata_server_log_group_name
  openmetadata_airflow_log_group_name = module.openmetadata_cloudwatch.openmetadata_airflow_log_group_name
  openmetadata_ecs_security_group_id  = module.openmetadata_security_group.openmetadata_ecs_security_group_id
  openmetadata_target_group_arn       = module.openmetadata_lb.openmetadata_target_group_arn
  ecr_depends_on                      = module.openmetadata_ecr.ecr_depends_on
}
