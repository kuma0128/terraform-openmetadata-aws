include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_repo_root()}//infra/terragrunt/modules/aws/openmetadata/ecs"
}

# ECR images must be built before ECS tasks can reference them.
# No outputs are consumed; this is purely for run --all ordering.
dependencies {
  paths = ["../ecr"]
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    subnet_a_private_id = "subnet-00000000000000001"
    subnet_c_private_id = "subnet-00000000000000002"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "iam" {
  config_path = "../iam"
  mock_outputs = {
    ecs_task_role_arn           = "arn:aws:iam::000000000000:role/mock-task-role"
    ecs_task_execution_role_arn = "arn:aws:iam::000000000000:role/mock-exec-role"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "secrets_manager" {
  config_path = "../secrets_manager"
  mock_outputs = {
    elasticsearch_password   = "mock-es-password"
    openmetadata_db_password = "mock-om-db-password"
    airflow_db_password      = "mock-af-db-password"
    airflow_admin_password   = "mock-af-admin-password"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "aurora" {
  config_path = "../aurora"
  mock_outputs = {
    aurora_cluster_endpoint = "mock-aurora.cluster-000000000000.ap-northeast-1.rds.amazonaws.com"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    docker_envfile_bucket_arn = "arn:aws:s3:::mock-envfile-bucket"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "cloudwatch" {
  config_path = "../cloudwatch"
  mock_outputs = {
    elastic_search_log_group_name       = "/ecs/mock-elasticsearch"
    migrate_all_log_group_name          = "/ecs/mock-migrate-all"
    openmetadata_server_log_group_name  = "/ecs/mock-openmetadata-server"
    openmetadata_airflow_log_group_name = "/ecs/mock-openmetadata-airflow"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "security_group" {
  config_path = "../security_group"
  mock_outputs = {
    openmetadata_ecs_security_group_id = "sg-00000000000000001"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "load_balancer" {
  config_path = "../load_balancer"
  mock_outputs = {
    openmetadata_target_group_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:000000000000:targetgroup/mock-tg/0000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "dns" {
  config_path = "../dns"
  mock_outputs = {
    domain_name = "ethan-example.com"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

inputs = {
  region                              = local.env.locals.region
  region_short_name                   = local.env.locals.region_short_name
  name_prefix                         = local.env.locals.name_prefix
  desired_count                       = local.env.locals.desired_count
  domain_name                         = dependency.dns.outputs.domain_name
  elasticsearch_tag                   = local.env.locals.elasticsearch_tag
  openmetadata_tag                    = local.env.locals.openmetadata_tag
  ingestion_tag                       = local.env.locals.ingestion_tag
  subnet_a_private_id                 = dependency.network.outputs.subnet_a_private_id
  subnet_c_private_id                 = dependency.network.outputs.subnet_c_private_id
  ecs_task_role_arn                   = dependency.iam.outputs.ecs_task_role_arn
  ecs_task_execution_role_arn         = dependency.iam.outputs.ecs_task_execution_role_arn
  elasticsearch_password              = dependency.secrets_manager.outputs.elasticsearch_password
  openmetadata_db_password            = dependency.secrets_manager.outputs.openmetadata_db_password
  airflow_db_password                 = dependency.secrets_manager.outputs.airflow_db_password
  airflow_admin_password              = dependency.secrets_manager.outputs.airflow_admin_password
  aurora_cluster_endpoint             = dependency.aurora.outputs.aurora_cluster_endpoint
  docker_envfile_bucket_arn           = dependency.s3.outputs.docker_envfile_bucket_arn
  elastic_search_log_group_name       = dependency.cloudwatch.outputs.elastic_search_log_group_name
  migrate_all_log_group_name          = dependency.cloudwatch.outputs.migrate_all_log_group_name
  openmetadata_server_log_group_name  = dependency.cloudwatch.outputs.openmetadata_server_log_group_name
  openmetadata_airflow_log_group_name = dependency.cloudwatch.outputs.openmetadata_airflow_log_group_name
  openmetadata_ecs_security_group_id  = dependency.security_group.outputs.openmetadata_ecs_security_group_id
  openmetadata_target_group_arn       = dependency.load_balancer.outputs.openmetadata_target_group_arn
}
