output "openmetadata_secret_name" {
  value       = aws_secretsmanager_secret.openmetadata.name
  description = "value of the openmetadata secret name"
}

output "aurora_secret_name" {
  value       = aws_secretsmanager_secret.aurora.name
  description = "value of the aurora secret name"
}

# expose generated passwords so other modules do not need to read secrets via
# data sources during planning. These values are already stored in state via the
# random_password resources, so this does not introduce additional secrets into
# the Terraform state.
output "aurora_password" {
  value       = random_password.aurora_password.result
  description = "generated password for the Aurora admin user"
}

output "elasticsearch_password" {
  value       = random_password.elasticsearch_password.result
  description = "generated password for the bundled Elasticsearch instance"
}

output "openmetadata_db_password" {
  value       = random_password.openmetadata_db_password.result
  description = "generated password for the OpenMetadata database"
}

output "airflow_db_password" {
  value       = random_password.airflow_db_password.result
  description = "generated password for the Airflow database"
}

output "airflow_admin_password" {
  value       = random_password.airflow_admin_password.result
  description = "generated password for the Airflow admin user"
}