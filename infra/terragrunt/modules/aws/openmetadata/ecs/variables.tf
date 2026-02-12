variable "domain_name" {
  type        = string
  description = "value of the domain name"
}

variable "region" {
  type        = string
  description = "value of the region"
}

variable "region_short_name" {
  type        = string
  description = "value of the region short name"
}

variable "name_prefix" {
  type        = string
  description = "value of the name prefix"
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

variable "desired_count" {
  type        = number
  description = "value of the desired count"
}

# child inputs
variable "subnet_a_private_id" {
  type        = string
  description = "value of the subnet a private id"
}

variable "subnet_c_private_id" {
  type        = string
  description = "value of the subnet c private id"
}

variable "openmetadata_target_group_arn" {
  type        = string
  description = "value of the openmetadata target group arn"
}

variable "openmetadata_ecs_security_group_id" {
  type        = string
  description = "value of the openmetadata ecs security group id"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "value of the ecs task role arn"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "value of the ecs task execution role arn"
}


variable "elasticsearch_password" {
  type        = string
  description = "password for the Elasticsearch container"
}

variable "openmetadata_db_password" {
  type        = string
  description = "password for the OpenMetadata database"
}

variable "airflow_db_password" {
  type        = string
  description = "password for the Airflow database"
}

variable "airflow_admin_password" {
  type        = string
  description = "password for the Airflow admin user"
}

variable "aurora_cluster_endpoint" {
  type        = string
  description = "value of the aurora cluster endpoint"
}

variable "docker_envfile_bucket_arn" {
  type        = string
  description = "value of the docker envfile bucket arn"
}

variable "elastic_search_log_group_name" {
  type        = string
  description = "value of the elastic search log group name"
}

variable "migrate_all_log_group_name" {
  type        = string
  description = "value of the migrate all log group name"
}

variable "openmetadata_server_log_group_name" {
  type        = string
  description = "value of the openmetadata server log group name"
}

variable "openmetadata_airflow_log_group_name" {
  type        = string
  description = "value of the openmetadata airflow log group name"
}
