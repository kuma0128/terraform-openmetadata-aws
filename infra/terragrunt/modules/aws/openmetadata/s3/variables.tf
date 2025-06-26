variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

variable "allowed_ip_list" {
  type        = list(string)
  description = "value of the allowed ip list"
}

variable "s3_gateway_endpoint_id" {
  type        = string
  description = "value of the s3 gateway endpoint id"
}

# child inputs
variable "s3_kms_key_arn" {
  type        = string
  description = "value of the s3 kms key arn"
}