terraform {
  backend "s3" {}
}

module "kms_key" {
  source            = "../../../modules/aws/openmetadata/kms_key"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
}

module "s3" {
  source                 = "../../../modules/aws/openmetadata/s3"
  name_prefix            = "${var.pj_name}-${var.env}"
  region_short_name      = var.region_short_name
  allowed_ip_list        = var.allowed_ip_list
  s3_gateway_endpoint_id = var.s3_gateway_endpoint_id
  s3_kms_key_arn         = module.openmetadata_kms_key.s3_kms_key_arn
}

module "iam" {
  source                    = "../../../modules/aws/openmetadata/iam"
  name_prefix               = "${var.pj_name}-${var.env}"
  region_short_name         = var.region_short_name
  docker_envfile_bucket_arn = module.openmetadata_s3.docker_envfile_bucket_arn
}

module "security_group" {
  source            = "../../../modules/aws/openmetadata/security_group"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
  allowed_ip_list   = var.allowed_ip_list
  vpc_id            = var.vpc_id
}

module "secretmanager" {
  source            = "../../../modules/aws/openmetadata/secrets_manager"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
  aurora_kms_key_id = module.openmetadata_kms_key.aurora_kms_key_id
}

module "cloudwatch" {
  source                = "../../../modules/aws/openmetadata/cloudwatch"
  log_retention_in_days = var.log_retention_in_days
  cloudwatch_kms_key_id = module.openmetadata_kms_key.cloudwatch_kms_key_id
}

module "aurora" {
  source                   = "../../../modules/aws/openmetadata/aurora"
  name_prefix              = "${var.pj_name}-${var.env}"
  region_short_name        = var.region_short_name
  subnet_a_private_id      = var.subnet_a_private_id
  subnet_c_private_id      = var.subnet_c_private_id
  aurora_kms_key_arn       = module.openmetadata_kms_key.aurora_kms_key_arn
  aurora_security_group_id = module.openmetadata_security_group.openmetaedata_aurora_security_group_id
  aurora_password          = module.openmetadata_secretmanager.aurora_password
  backup_retention_period  = var.backup_retention_period
  instance_count           = var.instance_count
}

module "ecr" {
  source            = "../../../modules/aws/openmetadata/ecr"
  ecr_kms_key_arn   = module.openmetadata_kms_key.ecr_kms_key_arn
  repository_list   = var.repository_list
  elasticsearch_tag = var.elasticsearch_tag
  openmetadata_tag  = var.openmetadata_tag
  ingestion_tag     = var.ingestion_tag
}

module "lb" {
  source                            = "../../../modules/aws/openmetadata/load_balancer"
  domain_name                       = var.domain_name
  name_prefix                       = "${var.pj_name}-${var.env}"
  region_short_name                 = var.region_short_name
  cert_arn                          = var.cert_arn
  route53_zone_id                   = var.route53_zone_id
  vpc_id                            = var.vpc_id
  subnet_a_public_id                = var.subnet_a_public_id
  subnet_c_public_id                = var.subnet_c_public_id
  openmetadata_lb_security_group_id = module.openmetadata_security_group.openmetadata_lb_security_group_id
}

module "ecs" {
  source                              = "../../../modules/aws/openmetadata/ecs"
  region                              = var.region
  region_short_name                   = var.region_short_name
  name_prefix                         = "${var.pj_name}-${var.env}"
  desired_count                       = var.desired_count
  subnet_a_private_id                 = var.subnet_a_private_id
  subnet_c_private_id                 = var.subnet_c_private_id
  domain_name                         = var.domain_name
  elasticsearch_tag                   = var.elasticsearch_tag
  openmetadata_tag                    = var.openmetadata_tag
  ingestion_tag                       = var.ingestion_tag
  ecs_task_role_arn                   = module.openmetadata_iam.ecs_task_role_arn
  ecs_task_execution_role_arn         = module.openmetadata_iam.ecs_task_execution_role_arn
  elasticsearch_password              = module.openmetadata_secretmanager.elasticsearch_password
  openmetadata_db_password            = module.openmetadata_secretmanager.openmetadata_db_password
  airflow_db_password                 = module.openmetadata_secretmanager.airflow_db_password
  airflow_admin_password              = module.openmetadata_secretmanager.airflow_admin_password
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
