terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket               = "gs-infra-tf-state-eurusdev" //change this bucket name with your own backend s3 bucket
    region               = "us-east-1"
    key                  = "backend.tfstate"
    workspace_key_prefix = "base_infra"
    dynamodb_table       = "terraform-state" //create a dynamodb table of your own with this name and LockID as its primary key
  }
}
