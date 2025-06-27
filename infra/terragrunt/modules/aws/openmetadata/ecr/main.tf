resource "aws_ecr_repository" "openmetadata" {
  for_each             = toset(var.repository_list)
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.ecr_kms_key_arn
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Build individually for out of memory measures
resource "terraform_data" "build_elasticsearch_image" {
  triggers_replace = [
    aws_ecr_repository.openmetadata["elasticsearch"].id,
    filesha256(data.archive_file.elasticsearch.output_path)
  ]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      sh ${path.module}/dockerfile/elasticsearch/image_build.sh
      EOT
    environment = {
      AWS_REGION     = data.aws_region.current.id
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
      TAG            = var.elasticsearch_tag
    }
  }
  depends_on = [aws_ecr_repository.openmetadata]
}

resource "terraform_data" "build_ingestion_image" {
  triggers_replace = [
    aws_ecr_repository.openmetadata["openmetadata/ingestion"].id,
    filesha256(data.archive_file.ingestion.output_path)
  ]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      sh ${path.module}/dockerfile/ingestion/image_build.sh
      EOT
    environment = {
      AWS_REGION     = data.aws_region.current.id
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
      TAG            = var.ingestion_tag
    }
  }
  depends_on = [terraform_data.build_elasticsearch_image]
}

resource "terraform_data" "build_openmetadata_image" {
  triggers_replace = [
    aws_ecr_repository.openmetadata["openmetadata/server"].id,
    filesha256(data.archive_file.openmetadata.output_path)
  ]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      sh ${path.module}/dockerfile/openmetadata/image_build.sh
      EOT
    environment = {
      AWS_REGION     = data.aws_region.current.id
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
      TAG            = var.openmetadata_tag
    }
  }
  depends_on = [terraform_data.build_ingestion_image]
}