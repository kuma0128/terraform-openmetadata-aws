variable "pj_name" {
  type        = string
  description = "Project name prefix"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "region_short_name" {
  type        = string
  description = "Short name for region"
}

variable "repo_full_name" {
  type        = string
  description = "GitHub repository full name"
}

variable "allowed_ip_list" {
  type        = list(string)
  description = "Allowed IP ranges"
}

variable "cidr_vpc" {
  type        = string
  description = "CIDR block for VPC"
}

variable "cidr_subnets_public" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "cidr_subnets_private" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "az_a_name" {
  type        = string
  description = "Availability zone A name"
}

variable "az_c_name" {
  type        = string
  description = "Availability zone C name"
}

variable "domain_name" {
  type        = string
  description = "Domain name for load balancer"
}

variable "repository_list" {
  type        = list(string)
  description = "ECR repository names"
}

variable "elasticsearch_tag" {
  type        = string
  description = "Elasticsearch image tag"
}

variable "openmetadata_tag" {
  type        = string
  description = "OpenMetadata image tag"
}

variable "ingestion_tag" {
  type        = string
  description = "Ingestion image tag"
}

variable "log_retention_in_days" {
  type        = number
  description = "CloudWatch log retention"
}

variable "backup_retention_period" {
  type        = number
  description = "Aurora backup retention period"
}

variable "instance_count" {
  type        = number
  description = "Number of Aurora DB instances"
}
