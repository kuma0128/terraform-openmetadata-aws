include {
  path = find_in_parent_folders()
}

terraform {
  # Include the entire Terraform directory so relative module
  # paths work correctly when Terragrunt copies the code.
  source = "../../../../..//infra/terraform/environment/dev/aws"
}
