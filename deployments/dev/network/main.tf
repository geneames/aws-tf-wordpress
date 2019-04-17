terraform {
  backend "s3" {
    bucket = "sema-terraform-state"
    region = "us-west-2"
    key = "dev/network/terraform.state"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

######################################################
# MODULES
######################################################
module "vpc" {
  source = "github.com/geneames/terraform-aws-vpc.git"

  cidr_block = "${var.network_address_space}"
  name = "wordpress"
  namespace = "sema"
  stage = "dev"
}