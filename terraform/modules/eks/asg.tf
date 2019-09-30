data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.main.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "aws_region" "current" { }

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.main.endpoint}' --b64-cluster-ca '${aws_eks_cluster.main.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "alc" {
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.eks_node_profile.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = var.worker_groups.instance_type
  name_prefix                 = "${terraform.workspace}-eks-alc"
  security_groups             = ["${aws_security_group.eks_node.id}"]
  user_data_base64            = "${base64encode(local.eks-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = var.worker_groups.asg_desired_capacity
  launch_configuration = aws_launch_configuration.alc.id
  max_size =  var.worker_groups.asg_max_size
  min_size = var.worker_groups.asg_min_size
  name                 = "${terraform.workspace}-eks-asg"
  vpc_zone_identifier  = "${var.private_subnets}"

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-eks-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster-name}"
    value               = "true"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = true
  }

}
