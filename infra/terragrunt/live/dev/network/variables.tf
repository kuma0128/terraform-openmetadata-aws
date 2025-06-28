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
