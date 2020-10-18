terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  region = "ap-southeast-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

module "webserver_cluster" {
  source = "git@github.com:greyson-yang/terraform-modules.git//services/webserver-cluster?ref=v0.0.1"
  
  cluster_name = "webservers-stage"
  db_remote_state_bucket = "greyson-terraform-state"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 3
}