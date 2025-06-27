variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

variable "env" {
  type        = string
  description = "deployment environment"
}

variable "domain_name" {
  type        = string
  description = "primary domain name"
}

variable "log_retention_in_days" {
  type        = number
  description = "log retention for query logs"
}

variable "dev_ns_records" {
  type        = list(string)
  description = "NS records for dev subdomain"
}

variable "stg_ns_records" {
  type        = list(string)
  description = "NS records for stg subdomain"
}
