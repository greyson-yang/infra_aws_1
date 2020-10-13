terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "greyson-terraform-state"
    key            = "global/mysql/terraform.tfstate"
    region         = "ap-southeast-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-rds"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"

  username            = "admin"

  name                = var.db_name
  skip_final_snapshot = true

  password            = var.db_password
}

