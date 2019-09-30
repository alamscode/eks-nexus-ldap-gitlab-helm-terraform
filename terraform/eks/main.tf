locals {
  vpc                 = data.terraform_remote_state.base_infra.outputs.network.vpc
  public_subnets_ids  = data.terraform_remote_state.base_infra.outputs.network.public_subnets_ids
  private_subnets_ids = data.terraform_remote_state.base_infra.outputs.network.private_subnets_ids
  eks_cluster_role    = data.terraform_remote_state.base_infra.outputs.iam.eks_cluster_role
  eks_node_role       = data.terraform_remote_state.base_infra.outputs.iam.eks_node_role
  eks_node_profile    = data.terraform_remote_state.base_infra.outputs.iam.eks_node_profile
  autoscaler_role     = data.terraform_remote_state.base_infra.outputs.iam.eks_autoscaler_role
}

module "eks" {
  source            = "../modules/eks"
  cluster-name      = var.cluster-name
  name              = "deployment"
  subnets           = concat([local.public_subnets_ids, local.private_subnets_ids])
  private_subnets   = flatten([local.private_subnets_ids])
  public_subnets    = flatten([local.public_subnets_ids])
  eks_cluster_role  = local.eks_cluster_role
  eks_node_role     = local.eks_node_role
  eks_node_profile  = local.eks_node_profile
  vpc_id            = local.vpc.id
  cidr              = local.vpc.cidr_block
  enable_kubectl    = true
  enable_dashboard  = true
  enable_kube2iam   = true
  worker_groups     = var.worker_groups
  region            = var.region
  autoscaler_role   = local.autoscaler_role
  nginx_ingress     = var.nginx_ingress
  external_dns      = var.external_dns
}
