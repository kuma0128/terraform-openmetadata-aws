output "openmetaedata_aurora_security_group_id" {
  value       = aws_security_group.aurora_sg.id
  description = "value of the openmetadata aurora security group id"
}

output "openmetadata_ecs_security_group_id" {
  value       = aws_security_group.ecs_sg.id
  description = "value of the openmetadata ecs security group id"
}

output "openmetadata_lb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "value of the openmetadata load balancer security group id"
}