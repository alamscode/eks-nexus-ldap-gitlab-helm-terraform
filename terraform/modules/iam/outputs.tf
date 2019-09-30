output "eks_node_role" {
  value = aws_iam_role.eks_node_role
}

output "eks_cluster_role" {
  value = aws_iam_role.eks_cluster_role
}

output "eks_node_profile" {
  value = aws_iam_instance_profile.eks_node_profile
}

output "eks_autoscaler_role" {
  value = aws_iam_role.eks_autoscaler_role
}
