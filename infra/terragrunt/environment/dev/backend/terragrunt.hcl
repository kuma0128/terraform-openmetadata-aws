include {
  path = find_in_parent_folders()
}

terraform {
  # Copy the full module tree so Terraform has access to all nested modules.
  # The `//backend` suffix ensures the backend module is used as the entry
  # point while the rest of the directory is preserved in the cache.
  source = "../../../module//backend"
}

dependencies {
  paths = ["../cicd"]
}

locals {
  pj_name              = "ethan"
  env                  = "dev"
  region_short_name    = "apne1"
  allowed_ip_list      = ["" ]
  github_actions_iam_role_id = []
  allowed_vpce_ids          = []
}

inputs = {
  pj_name                = local.pj_name
  env                    = local.env
  region_short_name      = local.region_short_name
  allowed_ip_list        = local.allowed_ip_list
  github_actions_iam_role_id = local.github_actions_iam_role_id
  allowed_vpce_ids       = local.allowed_vpce_ids
}
