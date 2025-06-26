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

# child inputs
variable "vpc_id" {
  type        = string
  description = "value of the vpc id"
}