terraform {
  backend "s3" {}
}

module "network" {
  source               = "../../../modules/aws/network"
  name_prefix          = "${var.pj_name}-${var.env}"
  region               = var.region
  region_short_name    = var.region_short_name
  az_a_name            = var.az_a_name
  az_c_name            = var.az_c_name
  cidr_vpc             = var.cidr_vpc
  cidr_subnets_public  = var.cidr_subnets_public
  cidr_subnets_private = var.cidr_subnets_private
}
