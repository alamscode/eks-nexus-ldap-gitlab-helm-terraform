data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh.tpl")}"
  vars = {
    bind_pass    =  var.bind_pass
    ldap_uri    =  var.ldap_uri
    bind_dn     =  var.bind_dn
    bind_base   =  var.bind_base
  }
}

resource "aws_security_group" "jump_host" {
  name   = "${terraform.workspace}-jump-host-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

}

resource "aws_instance" "jump_host" {
  ami                           = data.aws_ami.ubuntu.id
  instance_type                 = var.instance_type
  user_data                     = data.template_file.user_data.rendered
  key_name                      = var.key_name
  associate_public_ip_address   = var.associate_public_ip_address
  vpc_security_group_ids        = [ aws_security_group.jump_host.id ]
  subnet_id                     = var.subnet_id
  tags = {
    Name = "${terraform.workspace}-jump-host"
  }

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
  }
}
