output "openmetadata_target_group_arn" {
  value       = aws_lb_target_group.to_openmetadata.arn
  description = "value of the openmetadata target group arn"
}
