locals {
  state_bucket = "ethan-s3-apne1-tfstate"
  aws_region   = "ap-northeast-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket  = local.state_bucket
    key     = "ethan/${replace(path_relative_to_include(), "environment/", "")}/remote.tfstate"
    region  = local.aws_region
    encrypt                 = true
    skip_bucket_creation    = false
    skip_bucket_versioning  = false
  }
}

generate "provider" {
  path      = "generated_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOT
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
  required_version = "~> 1.12.2"
}

provider "aws" {}
provider "http" {}
provider "random" {}
EOT
}

terraform {
  before_hook "fmt" {
    commands = ["plan", "apply"]
    execute  = ["terraform", "fmt", "-check", "-recursive"]
  }

  before_hook "validate" {
    commands = ["plan", "apply"]
    execute  = ["terraform", "validate"]
  }
}
