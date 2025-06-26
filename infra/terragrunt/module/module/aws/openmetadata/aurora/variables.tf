variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

variable "subnet_a_private_id" {
  type        = string
  description = "value of the subnet a private id"
}

variable "subnet_c_private_id" {
  type        = string
  description = "value of the subnet c private id"
}

variable "aurora_kms_key_arn" {
  type        = string
  description = "value of the aurora kms key arn"
}

variable "aurora_security_group_id" {
  type        = string
  description = "value of the aurora security group id"
}

variable "aurora_secret_name" {
  type        = string
  description = "value of the aurora secret name"
}

variable "backup_retention_period" {
  type        = number
  description = "value of the backup retention period"
}

variable "instance_count" {
  type        = number
  description = "value of the instance count"
}