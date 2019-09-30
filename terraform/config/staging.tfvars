cidr = "10.4.0.0/16"
availability_zones  = ["us-east-1a","us-east-1b","us-east-1c"]
region        = "us-east-1"

worker_groups = {
    instance_type = "m4.large"
    asg_desired_capacity          = 1
    asg_max_size                  = 4
    asg_min_size                  = 1
}

cluster-name = "test_dns"

nginx_ingress = {
  version   = "0.25.1"
  acm_cert_arn = ""
}

external_dns = {
    version             = "v0.5.17"
    public_dns_role     = "arn:aws:iam::201526351103:role/Route53FromDevRegionFailure"
    public_domain_name  = "guidespark.net"
}

s3_replication_buckets = {
  jenkins_source_bucket_name = "jenkins"
  gitlab_source_bucket_name = "gitlab"
  nexus_source_bucket_name = "nexus"
}


key_name      = "test"

ldap_uri          = "ldaps://trambo.ldap.okta.com:636/"

bind_dn           = "uid=braulio@trambo.cloud,ou=users, dc=trambo, dc=okta, dc=com"

bind_base         = "ou=users, dc=trambo, dc=okta, dc=com"

s3_DR_buckets = {
  jenkins_dr_bucket_name_prefix = "guidespark-jenkins-dr"
  gitlab_dr_bucket_name_prefix = "guidespark-gitlab-dr"
  nexus_dr_bucket_name_prefix = "guidespark-nexus-dr"
}
