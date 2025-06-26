include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Copy the repo root so nested modules referenced by relative paths are
  # available in Terragrunt's cache. The
  # `//infra/terragrunt/environment/dev/cicd` suffix points to this directory as
  # the module entry.
  source = "${get_repo_root()}//infra/terragrunt/environment/dev/cicd"
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
