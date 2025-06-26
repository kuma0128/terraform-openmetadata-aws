variable "region" {
  type        = string
  description = "value of the region"
}

variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

variable "az_a_name" {
  type        = string
  description = "value of the az a name"
}

variable "az_c_name" {
  type        = string
  description = "value of the az c name"
}

variable "cidr_vpc" {
  type        = string
  description = "value of the cidr vpc"
}

variable "cidr_subnets_public" {
  type        = list(string)
  description = "value of the cidr subnets public"
}

variable "cidr_subnets_private" {
  type        = list(string)
  description = "value of the cidr subnets private"
}
