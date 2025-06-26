output "github_actions_iam_role_id" {
  value       = aws_iam_role.this.unique_id
  description = "value of the github actions iam role id"
}