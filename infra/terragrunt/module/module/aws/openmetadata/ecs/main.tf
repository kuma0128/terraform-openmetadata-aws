resource "aws_ecs_cluster" "this" {
  name = "${var.name_prefix}-ecs-${var.region_short_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "openmetadata" {
  family = "openmetadata"

  runtime_platform {
    operating_system_family = "LINUX"
  }

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "8192"
  memory                   = "16384"

  ephemeral_storage {
    size_in_gib = 60
  }

  task_role_arn      = var.ecs_task_role_arn
  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "openmetadata_elasticsearch"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/elasticsearch:${var.elasticsearch_tag}"
      essential = true

      ulimits = [
        {
          name      = "nofile"
          hardLimit = 65535
          softLimit = 65535
        }
      ]

      environment = [
        {
          name  = "ELASTIC_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["elasticsearch"]
        }
      ]

      environmentFiles = [
        {
          value = "${var.docker_envfile_bucket_arn}/elastic_search.env"
          type  = "s3"
        }
      ]

      portMappings = [
        {
          Protocol      = "tcp"
          containerPort = 9200
          hostPort      = 9200
        },
        {
          Protocol      = "tcp"
          containerPort = 9300
          hostPort      = 9300
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -s -u elastic:$ELASTIC_PASSWORD http://localhost:9200/_cluster/health?pretty | grep status | grep -qE 'green|yellow' || exit 1"]
        interval    = 15
        timeout     = 10
        retries     = 10
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.elastic_search_log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
    {
      name             = "openmetadata_execute_migrate_all"
      image            = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/openmetadata/server:${var.openmetadata_tag}"
      essential        = false
      entryPoint       = ["/bin/bash"]
      command          = ["./bootstrap/openmetadata-ops.sh", "migrate"]
      workingDirectory = "/opt/openmetadata"

      environment = [
        {
          name  = "DB_USER_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["openmetadata_db"]
        },
        {
          name  = "ELASTICSEARCH_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["elasticsearch"]
        },
        {
          name  = "AIRFLOW_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["airflow_admin"]
        },
        {
          name  = "JWT_ISSUER"
          value = var.domain_name
        },
        {
          name  = "DB_HOST"
          value = var.aurora_cluster_endpoint
        }
      ]

      environmentFiles = [
        {
          value = "${var.docker_envfile_bucket_arn}/migrate_all.env"
          type  = "s3"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.migrate_all_log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      dependsOn = [
        {
          containerName = "openmetadata_elasticsearch"
          condition     = "HEALTHY"
        }
      ]
    },
    {
      name      = "openmetadata_server"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/openmetadata/server:${var.openmetadata_tag}"
      essential = true

      environment = [
        {
          name  = "DB_USER_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["openmetadata_db"]
        },
        {
          name  = "ELASTICSEARCH_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["elasticsearch"]
        },
        {
          name  = "AIRFLOW_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["airflow_admin"]
        },
        {
          name  = "JWT_ISSUER"
          value = var.domain_name
        },
        {
          name  = "DB_HOST"
          value = var.aurora_cluster_endpoint
        }
      ]

      environmentFiles = [
        {
          value = "${var.docker_envfile_bucket_arn}/openmetadata_server.env"
          type  = "s3"
        }
      ]

      portMappings = [
        {
          containerPort = 8585
          hostPort      = 8585
        },
        {
          containerPort = 8586
          hostPort      = 8586
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.openmetadata_server_log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "wget -q --spider http://localhost:8586/healthcheck"]
        startPeriod = 120
      }

      dependsOn = [
        {
          containerName = "openmetadata_elasticsearch"
          condition     = "HEALTHY"
        },
        {
          containerName = "openmetadata_execute_migrate_all"
          condition     = "SUCCESS"
        }
      ]
    },
    {
      name       = "openmetadata_ingestion"
      image      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/openmetadata/ingestion:${var.ingestion_tag}"
      command    = ["/opt/airflow/ingestion_dependency.sh"]
      essential  = true
      entryPoint = ["/bin/bash"]

      environment = [
        {
          name  = "AIRFLOW_ADMIN_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["airflow_admin"]
        },
        {
          name  = "DB_PASSWORD"
          value = jsondecode(data.aws_secretsmanager_secret_version.openmetadata.secret_string)["airflow_db"]
        },
        {
          name  = "DB_HOST"
          value = var.aurora_cluster_endpoint
        }
      ]

      environmentFiles = [
        {
          value = "${var.docker_envfile_bucket_arn}/openmetadata_ingestion.env"
          type  = "s3"
        }
      ]

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.openmetadata_airflow_log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      dependsOn = [
        {
          containerName = "openmetadata_elasticsearch"
          condition     = "START"
        },
        {
          containerName = "openmetadata_server"
          condition     = "START"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name                   = "openmetadata-service"
  cluster                = aws_ecs_cluster.this.id
  task_definition        = aws_ecs_task_definition.openmetadata.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = true

  network_configuration {
    subnets         = [var.subnet_a_private_id, var.subnet_c_private_id]
    security_groups = [var.openmetadata_ecs_security_group_id]
  }

  wait_for_steady_state = true

  load_balancer {
    target_group_arn = var.openmetadata_target_group_arn
    container_name   = "openmetadata_server"
    container_port   = 8585
  }

  depends_on = [var.ecr_depends_on]
}