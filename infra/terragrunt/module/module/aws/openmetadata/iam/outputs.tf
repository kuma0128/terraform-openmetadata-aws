output "ecs_task_role_arn" {
  value       = aws_iam_role.ecs_task.arn
  description = "value of the ecs task role arn"
}

output "ecs_task_execution_role_arn" {
  value       = aws_iam_role.ecs_task_execution.arn
  description = "value of the ecs task execution role arn"
}