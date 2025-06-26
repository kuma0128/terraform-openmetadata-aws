resource "aws_s3_bucket" "this" {
  bucket = "${var.name_prefix}-s3-${var.region_short_name}-docker-envfile"
  tags = {
    Name = "${var.name_prefix}-s3-${var.region_short_name}-docker-envfile"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = templatefile(
    "${path.module}/bucket_policy/docker_env.json.tpl",
    {
      s3_bucket_arn     = aws_s3_bucket.this.arn
      allowed_aws_roles = []
      allowed_ips       = var.allowed_ip_list
      allowed_vpce_ids = [
        var.s3_gateway_endpoint_id
      ]
    }
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "terraform_data" "copy_docker_environments" {
  triggers_replace = [
    aws_s3_bucket.this.id,
    filesha256("${path.module}/environment_files/*.env"),
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      aws s3 cp \
      ${path.module}/environment_files/elastic_search.env s3://${aws_s3_bucket.this.id}/ \
      --no-progress \
      EOT
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      aws s3 cp \
      ${path.module}/environment_files/migrate_all.env s3://${aws_s3_bucket.this.id}/ \
      --no-progress \
      EOT
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      aws s3 cp \
      ${path.module}/environment_files/openmetadata_server.env s3://${aws_s3_bucket.this.id}/ \
      --no-progress \
      EOT
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      aws s3 cp \
      ${path.module}/environment_files/openmetadata_ingestion.env s3://${aws_s3_bucket.this.id}/ \
      --no-progress \
      EOT
  }
}