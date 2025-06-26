resource "aws_kms_key" "aurora" {
  description             = "For Aurora"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 365
  tags = {
    name = "${var.name_prefix}-kms-${var.region_short_name}-aurora"
  }
}

resource "aws_kms_alias" "aurora" {
  name          = "alias/${var.name_prefix}-kms-${var.region_short_name}-aurora"
  target_key_id = aws_kms_key.aurora.key_id
}

resource "aws_kms_key" "ecr" {
  description             = "For ECR"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 365
  tags = {
    name = "${var.name_prefix}-kms-${var.region_short_name}-ecr"
  }
}

resource "aws_kms_alias" "ecr" {
  name          = "alias/${var.name_prefix}-kms-${var.region_short_name}-ecr"
  target_key_id = aws_kms_key.ecr.key_id
}

resource "aws_kms_key" "s3" {
  description             = "For s3"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  rotation_period_in_days = 365
  tags = {
    name = "${var.name_prefix}-kms-${var.region_short_name}-s3-envfile"
  }
}

resource "aws_kms_alias" "s3" {
  name          = "alias/${var.name_prefix}-kms-${var.region_short_name}-s3-envfile"
  target_key_id = aws_kms_key.s3.key_id
}