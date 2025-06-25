terraform {
  # Backend is left empty so Terragrunt can configure it.
  backend "s3" {}
  required_version = "~> 1.12.2"
}
