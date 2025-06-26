terraform {
  backend "s3" {}
}

module "backend" {
  source                     = "../../../modules/backend"
  name_prefix                = "${var.pj_name}-${var.env}"
  region_short_name          = var.region_short_name
  allowed_ip_list            = var.allowed_ip_list
  github_actions_iam_role_id = var.github_actions_iam_role_id
  allowed_vpce_ids           = var.allowed_vpce_ids
}
