resource "aws_db_subnet_group" "aurora_group" {
  name = "${var.name_prefix}-aurora-${var.region_short_name}-subnet-group"
  subnet_ids = [
    var.subnet_a_private_id,
    var.subnet_c_private_id
  ]
}

resource "aws_rds_cluster_parameter_group" "aurora_param" {
  name   = "${var.name_prefix}-aurora-${var.region_short_name}-param-group"
  family = "aurora-postgresql16"
  parameter {
    name  = "timezone"
    value = "Asia/Tokyo"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier                  = "${var.name_prefix}-aurora-${var.region_short_name}-cluster"
  engine                              = "aurora-postgresql"
  engine_version                      = "16.2"
  engine_mode                         = "provisioned"
  database_name                       = "openmetadata"
  master_username                     = "openmetadata_admin"
  master_password                     = var.aurora_password
  storage_encrypted                   = true
  kms_key_id                          = var.aurora_kms_key_arn
  iam_database_authentication_enabled = true
  enable_http_endpoint                = true # for Data API
  deletion_protection                 = true
  db_subnet_group_name                = aws_db_subnet_group.aurora_group.name
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora_param.name
  vpc_security_group_ids              = [var.aurora_security_group_id]
  skip_final_snapshot                 = true
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = "08:00-08:30"
  preferred_maintenance_window        = "sun:09:00-sun:09:30"
  enabled_cloudwatch_logs_exports     = ["postgresql"]

  serverlessv2_scaling_configuration {
    min_capacity = 0
    max_capacity = 1
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count                                 = var.instance_count
  identifier                            = "${var.name_prefix}-aurora-${var.region_short_name}-instance-${count.index}"
  cluster_identifier                    = aws_rds_cluster.aurora.id
  instance_class                        = "db.serverless"
  engine                                = aws_rds_cluster.aurora.engine
  engine_version                        = aws_rds_cluster.aurora.engine_version
  auto_minor_version_upgrade            = true
  publicly_accessible                   = false
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  preferred_maintenance_window          = "sun:09:00-sun:09:30"
  db_subnet_group_name                  = aws_rds_cluster.aurora.db_subnet_group_name
}