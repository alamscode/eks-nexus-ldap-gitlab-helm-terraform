data "template_file" "nginx_ingress" {
  template = "${file("${path.module}/templates/nginx-ingress-controller.yaml.tpl")}"
  vars = {
    nginx_ingress_version         = var.nginx_ingress.version
    nginx_ingress_cert            = var.nginx_ingress.acm_cert_arn
  }
}

resource "local_file" "nginx_ingress" {
  content  = data.template_file.nginx_ingress.rendered
  filename = "${path.root}/output/${var.cluster-name}/nginx_ingress.yaml"
}


resource "null_resource" "nginx_ingress" {
  depends_on = [ local_file.cluster_autoscaler ]
  provisioner "local-exec" {
    command = "kubectl apply -f${path.root}/output/${var.cluster-name}/nginx_ingress.yaml"

    environment = {
      KUBECONFIG = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
    }
  }

  triggers = {
    cluster_autoscaler = data.template_file.nginx_ingress.rendered
  }
}
