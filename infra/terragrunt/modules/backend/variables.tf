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

variable "github_actions_iam_role_id" {
  type        = list(string)
  description = "value of the github actions iam role id"
}

variable "allowed_vpce_ids" {
  type        = list(string)
  description = "value of the allowed vpce ids"
}
