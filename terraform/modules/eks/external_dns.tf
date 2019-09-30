data "template_file" "external_dns_public" {
  depends_on = [ null_resource.kube2iam ]
  template = "${file("${path.module}/templates/external-dns.yaml.tpl")}"
    vars = {
      cluster_name                      = var.cluster-name
      domain_name                       = var.external_dns.public_domain_name
      dns_role                          = var.external_dns.public_dns_role
      zone_type                         = "public"
      policy                            = "sync"
      pod_name                          = "external-dns-public"
      external_dns_version              = var.external_dns.version
  }
}

resource "local_file" "external_dns_public" {
  content  = "${data.template_file.external_dns_public.rendered}"
  filename = "${path.root}/output/${var.cluster-name}/external_dns_public.yaml"
}

resource "null_resource" "external_dns_public" {
  depends_on = [ local_file.external_dns_public ]
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.root}/output/${var.cluster-name}/external_dns_public.yaml"

    environment = {
      KUBECONFIG = "${path.root}/output/${var.cluster-name}/kubeconfig-${var.cluster-name}"
    }
  }

  triggers = {
    external_dns_public = data.template_file.external_dns_public.rendered
  }
}
