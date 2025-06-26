data "aws_secretsmanager_secret" "aurora" {
  name = var.aurora_secret_name
}

data "aws_secretsmanager_secret_version" "aurora" {
  secret_id = data.aws_secretsmanager_secret.aurora.id
}