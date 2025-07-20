resource "aws_cloudwatch_log_group" "elastic_search" {
  name              = "/aws/ecs/elastic-search"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id
}

resource "aws_cloudwatch_log_group" "migrate_all" {
  name              = "/aws/ecs/migrate-all"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id
}

resource "aws_cloudwatch_log_group" "openmetadata_server" {
  name              = "/aws/ecs/openmetadata-server"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id
}

resource "aws_cloudwatch_log_group" "openmetadata_airflow" {
  name              = "/aws/ecs/openmetadata-airflow"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id
}