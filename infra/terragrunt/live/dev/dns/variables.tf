variable "pj_name" {
  type        = string
  description = "Project name prefix"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "region_short_name" {
  type        = string
  description = "Short name for region"
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "log_retention_in_days" {
  type        = number
  description = "Log retention for query logs"
}

variable "dev_ns_records" {
  type        = list(string)
  description = "NS records for dev subdomain"
}

variable "stg_ns_records" {
  type        = list(string)
  description = "NS records for stg subdomain"
}
