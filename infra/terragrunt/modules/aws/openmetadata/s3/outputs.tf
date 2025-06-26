output "docker_envfile_bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "value of the docker envfile bucket arn"
}