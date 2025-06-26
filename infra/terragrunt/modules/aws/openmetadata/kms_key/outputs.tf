output "aurora_kms_key_arn" {
  value       = aws_kms_key.aurora.arn
  description = "value of the aurora kms key arn"
}

output "ecr_kms_key_arn" {
  value       = aws_kms_key.ecr.arn
  description = "value of the ecr kms key arn"
}

output "s3_kms_key_arn" {
  value       = aws_kms_key.s3.arn
  description = "value of the s3 kms key arn"
}