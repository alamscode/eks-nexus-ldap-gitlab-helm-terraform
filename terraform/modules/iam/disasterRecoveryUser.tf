resource "aws_iam_user" "disasterRecoveryUser" {
  name = "DisasterRecovery-${terraform.workspace}"
  tags = {
    Name = "Data Replication User"
    Environment: "${terraform.workspace}"
  }
}

resource "aws_iam_access_key" "disasterRecoveryUserKey" {
  user = "${aws_iam_user.disasterRecoveryUser.name}"
}

resource "aws_iam_user_policy" "disasterRecoveryUserPolicy" {
  name = "disasterRecoveryUserPolicy"
  user = "${aws_iam_user.disasterRecoveryUser.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_replication_buckets.jenkins_source_bucket_name}",
                "arn:aws:s3:::${var.s3_replication_buckets.jenkins_source_bucket_name}/*",
                "arn:aws:s3:::${var.s3_replication_buckets.gitlab_source_bucket_name}",
                "arn:aws:s3:::${var.s3_replication_buckets.gitlab_source_bucket_name}/*",
                "arn:aws:s3:::${var.s3_replication_buckets.nexus_source_bucket_name}",
                "arn:aws:s3:::${var.s3_replication_buckets.nexus_source_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_DR_buckets.jenkins_dr_bucket_name_prefix}-${terraform.workspace}",
                "arn:aws:s3:::${var.s3_DR_buckets.jenkins_dr_bucket_name_prefix}-${terraform.workspace}/*",
                "arn:aws:s3:::${var.s3_DR_buckets.gitlab_dr_bucket_name_prefix}-${terraform.workspace}",
                "arn:aws:s3:::${var.s3_DR_buckets.gitlab_dr_bucket_name_prefix}-${terraform.workspace}/*",
                "arn:aws:s3:::${var.s3_DR_buckets.nexus_dr_bucket_name_prefix}-${terraform.workspace}",
                "arn:aws:s3:::${var.s3_DR_buckets.nexus_dr_bucket_name_prefix}-${terraform.workspace}/*"
            ]
        }
    ]
}
EOF
}