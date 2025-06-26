data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "elasticsearch" {
  type        = "zip"
  source_dir  = "${path.module}/dockerfile/elasticsearch"
  output_path = "${path.module}/dockerfile/elasticsearch/elasticsearch.zip"
}

data "archive_file" "openmetadata" {
  type        = "zip"
  source_dir  = "${path.module}/dockerfile/openmetadata"
  output_path = "${path.module}/dockerfile/openmetadata/openmetadata.zip"
}

data "archive_file" "ingestion" {
  type        = "zip"
  source_dir  = "${path.module}/dockerfile/ingestion"
  output_path = "${path.module}/dockerfile/ingestion/ingestion.zip"
}