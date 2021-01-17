provider "aws" {
  region  = "ap-southeast-2"
}

data "aws_availability_zones" "available" {}

locals {
  name = "demo-vpc-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source = "../modules/network/vpc"

  name                 = local.name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  map_public_ip_on_launch  = true
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key-pair" {
  source = "../modules/vault/key-pair"

  key_name   = "dev"
  public_key = tls_private_key.this.public_key_openssh
}

module "ec2_cluster" {
  source                 = "../modules/compute/ec2"

  name                   = "demo-ec2-cluster"
  instance_count         = 3
  ami                    = "ami-0987943c813a8426b"
  instance_type          = "t2.micro"
  key_name               = module.key-pair.this_key_pair_key_name
  monitoring             = true
  // vpc_security_group_ids = ["sg-12345678"]
  subnet_ids              = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}