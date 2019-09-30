resource "aws_s3_bucket" "jenkins_DR_bucket" {
  bucket = "${var.s3_DR_buckets.jenkins_dr_bucket_name_prefix}-${terraform.workspace}"
  acl = "private"
  tags = {
    Name = "Jenkins DR Bucket"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_s3_bucket" "gitlab_DR_bucket" {
  bucket = "${var.s3_DR_buckets.gitlab_dr_bucket_name_prefix}-${terraform.workspace}"
  acl = "private"
  tags = {
    Name = "Gitlab DR Bucket"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_s3_bucket" "nexus_DR_bucket" {
  bucket = "${var.s3_DR_buckets.nexus_dr_bucket_name_prefix}-${terraform.workspace}"
  acl = "private"
  tags = {
    Name = "Nexus DR Bucket"
    Environment = "${terraform.workspace}"
  }
}
