include {
  path = find_in_parent_folders()
}

terraform {
  # Copy the entire module directory so that nested modules referenced by
  # relative paths are available during execution. Using the `//cicd` suffix
  # instructs Terragrunt/Terraform to run the `cicd` subdirectory while
  # including the rest of the module files in the cache.
  source = "../../../module//cicd"
}

locals {
  pj_name           = "ethan"
  env               = "dev"
  region_short_name = "apne1"
  repo_full_name    = "kuma0128/terraform-openmetadata-aws-assets"
}

inputs = {
  pj_name           = local.pj_name
  env               = local.env
  region_short_name = local.region_short_name
  repo_full_name    = local.repo_full_name
}
