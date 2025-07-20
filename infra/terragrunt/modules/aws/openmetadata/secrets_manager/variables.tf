variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

variable "aurora_kms_key_id" {
  type        = string
  description = "ID of the KMS key for Aurora"
}