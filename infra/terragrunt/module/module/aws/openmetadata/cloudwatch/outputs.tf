output "elastic_search_log_group_name" {
  value       = aws_cloudwatch_log_group.elastic_search.name
  description = "value of the elastic search log group name"
}

output "migrate_all_log_group_name" {
  value       = aws_cloudwatch_log_group.migrate_all.name
  description = "value of the migrate all log group name"
}

output "openmetadata_server_log_group_name" {
  value       = aws_cloudwatch_log_group.openmetadata_server.name
  description = "value of the openmetadata server log group name"
}

output "openmetadata_airflow_log_group_name" {
  value       = aws_cloudwatch_log_group.openmetadata_airflow.name
  description = "value of the openmetadata airflow log group name"
}