# for Aurora
resource "random_password" "aurora_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "aurora" {
  name                    = "${var.name_prefix}-secret-${var.region_short_name}-aurora"
  description             = ""
  recovery_window_in_days = 30

  tags = {
    Name = "${var.name_prefix}-secret-${var.region_short_name}-aurora"
  }
}

resource "aws_secretsmanager_secret_version" "aurora" {
  secret_id = aws_secretsmanager_secret.aurora.id
  secret_string = jsonencode({
    username = "openmetadata_admin"
    password = random_password.aurora_password.result
  })
}

# for OpenMetadata
resource "random_password" "elasticsearch_password" {
  length  = 16
  special = false
}

resource "random_password" "openmetadata_db_password" {
  length  = 16
  special = false
}

resource "random_password" "airflow_db_password" {
  length  = 16
  special = false
}

resource "random_password" "airflow_admin_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "openmetadata" {
  name                    = "${var.name_prefix}-secret-${var.region_short_name}-openmetadata"
  description             = "List of initial user passwords required when building OpenMetadata"
  recovery_window_in_days = 30

  tags = {
    Name = "${var.name_prefix}-secret-${var.region_short_name}-openmetadata"
  }
}

resource "aws_secretsmanager_secret_version" "openmetadata" {
  secret_id = aws_secretsmanager_secret.openmetadata.id
  secret_string = jsonencode({
    elasticsearch   = random_password.elasticsearch_password.result
    openmetadata_db = random_password.openmetadata_db_password.result
    airflow_db      = random_password.airflow_db_password.result
    airflow_admin   = random_password.airflow_admin_password.result
  })
}