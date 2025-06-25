terraform {
  # Include the entire Terraform directory so relative module
  # paths work correctly when Terragrunt copies the code.
  source = "../../../../..//infra/terraform/environment/dev/aws"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "ethan-s3-apne1-tfstate"
    key    = "ethan/dev/aws/remote.tfstate"
    region = "ap-northeast-1"
    encrypt = true
  }
}

generate "provider" {
  path = "generated_provider.tf"
  if_exists = "overwrite"
  contents = <<EOT
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
