output "eks_shell_vars" {
  description = "varibles to be exported for kubectl commands"
  value       = module.eks.shell_vars
}
