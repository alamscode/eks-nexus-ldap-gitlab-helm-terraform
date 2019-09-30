locals {
  vpc                 = data.terraform_remote_state.base_infra.outputs.network.vpc
  public_subnets_ids  = data.terraform_remote_state.base_infra.outputs.network.public_subnets_ids
  private_subnets_ids = data.terraform_remote_state.base_infra.outputs.network.private_subnets_ids
}

data "aws_ssm_parameter" "bind_pass" {
  name = "/${terraform.workspace}/bind_pass"
}

module "jump-host" {
  source            = "../modules/jump-host"
  vpc_id            = local.vpc.id
  key_name          = var.key_name
  subnet_id         = element(local.public_subnets_ids, 0)
  ldap_uri          = var.ldap_uri
  bind_dn           = var.bind_dn
  bind_base         = var.bind_base
  bind_pass         = data.aws_ssm_parameter.bind_pass.value
  region            = var.region
}
