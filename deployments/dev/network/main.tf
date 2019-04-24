######################################################
# Local Variables
######################################################
locals {
  public_cidr_block  = "${cidrsubnet(var.cidr_block, 2, 3)}"
  private_cidr_block = "${cidrsubnet(var.cidr_block, 0, 0)}"
  availability_zones = "${var.availability_zones}"
}

######################################################
# MODULES
######################################################
module "vpc" {
  source = "git@github.com:geneames/terraform-aws-vpc.git?ref=tags/0.1"

  cidr_block = "${var.cidr_block}"
  name = "wordpress"
  namespace = "sema"
  stage = "dev"
}

module "private_subnets" {
  source             = "git@github.com:geneames/terraform-aws-multi-az-subnets.git?ref=tags/0.1"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = "${local.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.private_cidr_block}"
  type               = "private"
  max_subnets = "${var.max_subnets}"
  az_ngw_ids = "${module.public_subnets.az_ngw_ids}"

  # Need to explicitly provide the count since Terraform currently can't use dynamic count on computed resources from different modules
  # https://github.com/hashicorp/terraform/issues/10857
  # https://github.com/hashicorp/terraform/issues/12125
  # https://github.com/hashicorp/terraform/issues/4149
  az_ngw_count = "3"
}

module "public_subnets" {
  source             = "git@github.com:geneames/terraform-aws-multi-az-subnets.git?ref=0.1"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = "${local.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.public_cidr_block}"
  type               = "public"
  max_subnets = "${var.max_subnets}"
  nat_gateway_enabled = "true"
  igw_id = "${module.vpc.igw_id}"
}
