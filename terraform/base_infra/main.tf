module "network" {
  source             = "../modules/network"
  availability_zones = var.availability_zones
  cidr               = var.cidr
}

module "iam" {
  source                      = "../modules/iam"
  public_dns_role             = var.external_dns.public_dns_role
  s3_DR_buckets               = var.s3_DR_buckets
  s3_replication_buckets      = var.s3_replication_buckets
}

module "s3" {
  source                     = "../modules/s3"
  s3_replication_buckets     = var.s3_replication_buckets
  s3_DR_buckets              = var.s3_DR_buckets
}