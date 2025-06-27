terraform {
  backend "s3" {}
}

module "dns" {
  source                = "../../../modules/aws/dns"
  name_prefix           = "${var.pj_name}-${var.env}"
  region_short_name     = var.region_short_name
  env                   = var.env
  domain_name           = var.domain_name
  log_retention_in_days = var.log_retention_in_days
  dev_ns_records        = var.dev_ns_records
  stg_ns_records        = var.stg_ns_records
}

output "openmetadata_zone_id" {
  value = module.dns.openmetadata_zone_id
}

output "cert_arn" {
  value = module.dns.cert_arn
}
