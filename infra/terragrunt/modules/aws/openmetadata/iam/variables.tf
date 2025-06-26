variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

# child inputs
variable "docker_envfile_bucket_arn" {
  type        = string
  description = "value of the docker envfile bucket arn"
}