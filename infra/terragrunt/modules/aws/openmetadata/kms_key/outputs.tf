output "aurora_kms_key_arn" {
  value       = aws_kms_key.aurora.arn
  description = "value of the aurora kms key arn"
}

output "aurora_kms_key_id" {
  value       = aws_kms_key.aurora.id
  description = "value of the aurora kms key id"
}

output "ecr_kms_key_arn" {
  value       = aws_kms_key.ecr.arn
  description = "value of the ecr kms key arn"
}


output "s3_kms_key_arn" {
  value       = aws_kms_key.s3.arn
  description = "value of the s3 kms key arn"
}

output "cloudwatch_kms_key_id" {
  value       = aws_kms_key.cloudwatch.id
  description = "value of the cloudwatch kms key id"
}
