terraform {
  backend "s3" {}
}

module "backend" {
  source = "../../../modules/backend"
  # Use project name only so the backend bucket matches the global state bucket
  name_prefix                = var.pj_name
  region_short_name          = var.region_short_name
  allowed_ip_list            = var.allowed_ip_list
  github_actions_iam_role_id = var.github_actions_iam_role_id
  allowed_vpce_ids           = var.allowed_vpce_ids
}
