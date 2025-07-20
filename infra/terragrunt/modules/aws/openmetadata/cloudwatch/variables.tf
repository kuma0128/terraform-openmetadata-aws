variable "log_retention_in_days" {
  type        = number
  description = "value of the log retention in days"
}

variable "cloudwatch_kms_key_id" {
  description = "ID of the customer-managed KMS key to encrypt CloudWatch Log Groups"
  type        = string
}