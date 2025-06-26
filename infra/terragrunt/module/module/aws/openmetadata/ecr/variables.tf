variable "repository_list" {
  type        = list(string)
  description = "value of the repository list"
}

variable "elasticsearch_tag" {
  type        = string
  description = "value of the elasticsearch tag"
}

variable "openmetadata_tag" {
  type        = string
  description = "value of the openmetadata tag"
}

variable "ingestion_tag" {
  type        = string
  description = "value of the ingestion tag"
}

# child inputs
variable "ecr_kms_key_arn" {
  type        = string
  description = "value of the ecr kms key arn"
}