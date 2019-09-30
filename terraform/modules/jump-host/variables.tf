variable "vpc_id" {
}

variable "key_name" {
}

variable "subnet_id" {
}

variable "ldap_uri" {
}

variable "bind_dn" {
}

variable "bind_base" {
}

variable "bind_pass"{
}

variable "region" {
  default = "us-east-1"
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = "10"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "associate_public_ip_address" {
  default = true
}
