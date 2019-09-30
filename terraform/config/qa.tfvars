cidr = "10.2.0.0/16"
availability_zones  = ["us-east-1a","us-east-1b"]
region        = "us-east-1"

worker_groups = {
    instance_type = "m4.large"
    asg_desired_capacity          = 1
    asg_max_size                  = 3
    asg_min_size                  = 1
}

cluster-name = "testme"
