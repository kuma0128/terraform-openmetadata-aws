output "aurora_cluster_endpoint" {
  value       = aws_rds_cluster.aurora.endpoint
  description = "value of the aurora cluster endpoint"
}
