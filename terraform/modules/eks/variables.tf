variable "cidr" {
}

variable "name" {
  type        = "string"
  description = "Name to be used on all the EKS Cluster resources as identifier."
}

variable "subnets" {

}

variable "private_subnets" {

}

variable "public_subnets" {

}

variable "cluster-name" {
  default = "qa_eks_cluster"
  type    = "string"
}

variable "vpc_id" {

}

variable "associate_public_ip_address" {
  default     = false
}

variable "worker_groups" {
  type = object({
    instance_type = string
    asg_desired_capacity = number
    asg_max_size = number
    asg_min_size = number
  })
}

variable "enable_kubectl" {
  default     = false
  description = "When enabled, it will merge the cluster's configuration with the one located in ~/.kube/config."
}

variable "enable_dashboard" {
  default     = false
  description = "When enabled, it will install the Kubernetes Dashboard."
}

variable "enable_calico" {
  default     = false
  description = "When enabled, it will install Calico for network policy support."
}

variable "enable_kube2iam" {
  default     = false
  description = "When enabled, it will install Kube2IAM to support assigning IAM roles to Pods."
}

variable "region" {

}

variable "eks_cluster_role" {

}

variable "eks_node_role" {

}

variable "autoscaler_role" {

}

variable "eks_node_profile" {

}

variable "autoscaler_version" {
  description = "Cluster Autoscaler version"
  type    = "string"
  default = "v1.13.6"
}

variable "nginx_ingress" {
  type = object({
    version             = string
    acm_cert_arn        = string
  })
}

variable "external_dns" {
  type = object({
    version             = string
    public_dns_role     = string
    public_domain_name  = string
  })
}
