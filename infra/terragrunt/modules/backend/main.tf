data "aws_s3_bucket" "this" {
  bucket = "${var.name_prefix}-s3-${var.region_short_name}-tfstate"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = data.aws_s3_bucket.this.id
  policy = templatefile(
    "${path.module}/bucket_policy/backend.json.tpl",
    {
      s3_bucket_arn     = data.aws_s3_bucket.this.arn
      allowed_aws_roles = var.github_actions_iam_role_id
      allowed_vpce_ids  = var.allowed_vpce_ids
      allowed_ips       = var.allowed_ip_list
    }
  )
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = data.aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = data.aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
