terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket               = "gs-infra-tf-state"  //change this bucket name with your own backend s3 bucket
    region               = "us-east-1"
    key                  = "backend.tfstate"
    workspace_key_prefix = "jump_host"
    dynamodb_table       = "terraform-state"
  }
}
