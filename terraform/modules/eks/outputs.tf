output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "shell_vars" {
  description = "varibles to be exported for kubectl commands"

  value = <<EOF
export AWS_REGION="${data.aws_region.current.name}"
export KUBECONFIG="${abspath(path.root)}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
EOF
}
