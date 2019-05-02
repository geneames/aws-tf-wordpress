provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "sema-terraform-state"
    region = "us-west-2"
    key = "dev/web-tier/load-balancer/terraform.state"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}
