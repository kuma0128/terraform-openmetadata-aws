terraform {
  backend "s3" {}
}

module "iam_github_oidc" {
  source            = "../module/aws/iam_github_oidc"
  name_prefix       = "${var.pj_name}-${var.env}"
  region_short_name = var.region_short_name
  repo_full_name    = var.repo_full_name
}
