# Remote state of management VPC
data "terraform_remote_state" "base_infra" {
  backend   = "s3"
  config = {
    bucket  = "gs-infra-tf-state-eurusdev" //change this bucket name with your own backend s3 bucket
    key     = "base_infra/${terraform.workspace}/backend.tfstate"
    region  = "us-east-1"
  }
}
