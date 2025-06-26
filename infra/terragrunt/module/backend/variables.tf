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

variable "allowed_ip_list" {
  type        = list(string)
  description = "Allowed IP ranges"
}

variable "github_actions_iam_role_id" {
  type        = list(string)
  description = "GitHub Actions IAM role IDs"
}

variable "allowed_vpce_ids" {
  type        = list(string)
  description = "Allowed VPC endpoint IDs"
}
