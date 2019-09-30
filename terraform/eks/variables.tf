variable "cluster-name" {
  type    = "string"
}

variable "region" {
  type    = "string"
}

variable "worker_groups" {
  type = object({
    instance_type = string
    asg_desired_capacity = number
    asg_max_size = number
    asg_min_size = number
  })
}

variable "nginx_ingress" {
  type = object({
    version   = string
    acm_cert_arn = string
  })
}

variable "external_dns" {
  type = object({
    version             = string
    public_dns_role     = string
    public_domain_name  = string
  })
}
