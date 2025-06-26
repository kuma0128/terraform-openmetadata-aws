data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "openmetadata" {
  name = var.openmetadata_secret_name
}

data "aws_secretsmanager_secret_version" "openmetadata" {
  secret_id = data.aws_secretsmanager_secret.openmetadata.id
}