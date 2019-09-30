variable "cidr" {
}

variable "availability_zones" {
  type = list(string)
}

variable "region" {
}

variable "external_dns" {
  type = object({
    version             = string
    public_dns_role     = string
    public_domain_name  = string
  })
}

variable "s3_replication_buckets" {
  type = object({
      jenkins_source_bucket_name = string
      gitlab_source_bucket_name = string
      nexus_source_bucket_name = string
  })
}

variable "s3_DR_buckets" {
  type = object({
    jenkins_dr_bucket_name_prefix = string
    gitlab_dr_bucket_name_prefix = string
    nexus_dr_bucket_name_prefix = string
  })
}
