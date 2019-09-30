resource "aws_iam_role" "eks_container_role_gitlab" {
  name = "terraform-${terraform.workspace}-eks-container-role-gitlab"
  depends_on = [ aws_iam_role.eks_node_role ]
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.eks_node_role.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "eks_container_policy_gitlab" {
  depends_on = [ aws_iam_role.eks_container_role_gitlab ]
  name = "terraform-${terraform.workspace}-eks-container-policy-gitlab"
  role = aws_iam_role.eks_container_role_gitlab.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Resource": [
              "arn:aws:s3:::${var.s3_DR_buckets.gitlab_dr_bucket_name_prefix}-${terraform.workspace}",
              "arn:aws:s3:::${var.s3_DR_buckets.gitlab_dr_bucket_name_prefix}-${terraform.workspace}/*"
            ]
        }
    ]
}
EOF
}