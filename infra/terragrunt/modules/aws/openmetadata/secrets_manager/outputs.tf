output "openmetadata_secret_name" {
  value       = aws_secretsmanager_secret.openmetadata.name
  description = "value of the openmetadata secret name"
}

output "aurora_secret_name" {
  value       = aws_secretsmanager_secret.aurora.name
  description = "value of the aurora secret name"
}