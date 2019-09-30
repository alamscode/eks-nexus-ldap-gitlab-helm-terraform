
// Only needed when route53 in the same account is being used
// resource "aws_iam_role" "eks-dns-role" {
//   name = "terraform-${terraform.workspace}-eks-dns-role"
//   assume_role_policy = <<POLICY
// {
//   "Version": "2012-10-17",
//   "Statement": [
//     {
//       "Effect": "Allow",
//       "Principal": {
//         "Service": "ec2.amazonaws.com"
//       },
//       "Action": "sts:AssumeRole"
//     },
//     {
//       "Sid": "",
//       "Effect": "Allow",
//       "Principal": {
//         "AWS": "${aws_iam_role.eks_node_role.arn}"
//       },
//       "Action": "sts:AssumeRole"
//     }
//   ]
// }
// POLICY
// }
//
// resource "aws_iam_role_policy" "eks-dns-policy" {
//   depends_on = ["aws_iam_role.eks-dns-role"]
//   name = "terraform-${terraform.workspace}-eks-dns-policy"
//   role = aws_iam_role.eks-dns-role.name
//   policy = <<EOF
// {
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Action": [
//        "route53:ChangeResourceRecordSets"
//      ],
//      "Resource": [
//        "arn:aws:route53:::hostedzone/*"
//      ]
//    },
//    {
//      "Effect": "Allow",
//      "Action": [
//        "route53:ListHostedZones",
//        "route53:ListResourceRecordSets"
//      ],
//      "Resource": [
//        "*"
//      ]
//    }
//  ]
// }
// EOF
// }

resource "aws_iam_policy"  "external-dns" {
  name = "terraform-${terraform.workspace}-external-dns"
  depends_on = [ aws_iam_role.eks_node_role ]
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Action": "sts:AssumeRole",
		"Resource": "${var.public_dns_role}"
	}]
}
EOF
}
