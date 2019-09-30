# Dashboard
resource "local_file" "eks_admin" {
  count = var.enable_dashboard ? 1 : 0

  content  = local.eks_admin
  filename = "${path.root}/output/${var.cluster-name}/eks-admin.yaml"

  depends_on = [
    null_resource.output

  ]
}

resource "null_resource" "dashboard" {
  depends_on = [ null_resource.autoscaler ]
  count = var.enable_dashboard ? 1 : 0

  provisioner "local-exec" {
    command = <<COMMAND
      kubectl apply -f ${path.module}/templates/kubernetes-dashboard.yaml \
      && kubectl apply -f ${path.module}/templates/heapster.yaml \
      && kubectl apply -f ${path.module}/templates/influxdb.yaml \
      && kubectl apply -f ${path.module}/templates/heapster-rbac.yaml \
      && kubectl apply -f ${path.root}/output/${var.cluster-name}/eks-admin.yaml \
      && kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
    COMMAND

    environment = {
      KUBECONFIG = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
    }
  }
}

# helm
resource "null_resource" "helm" {

  provisioner "local-exec" {
    command = <<COMMAND
      kubectl -n kube-system create serviceaccount tiller
      kubectl patch serviceaccount default -p "automountServiceAccountToken: true"
      kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
      helm init --service-account tiller --wait
    COMMAND

    environment = {
      KUBECONFIG = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
    }
  }

  depends_on = [
    local_file.eks_admin,
    null_resource.output,
    null_resource.aws_auth
  ]
}

# kube2iam
resource "local_file" "kube2iam" {
  count = var.enable_kube2iam ? 1 : 0

  content  = local.kube2iam
  filename = "${path.root}/output/${var.cluster-name}/kube2iam.yaml"

  depends_on = [
    null_resource.output
  ]
}

resource "null_resource" "kube2iam" {
  count = var.enable_kube2iam ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.root}/output/${var.cluster-name}/kube2iam.yaml"

    environment = {
      KUBECONFIG = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
    }

  }

  depends_on = [
    null_resource.aws_auth
  ]
}

 // Calico
resource "null_resource" "calico" {
  count = var.enable_calico ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/templates/aws-k8s-cni-calico.yaml"

    environment = {
      KUBECONFIG = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
    }
  }

  depends_on = [
    null_resource.aws_auth
  ]
}
