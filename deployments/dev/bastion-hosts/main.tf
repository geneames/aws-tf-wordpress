######################################################
# Local Variables
######################################################
locals {

}

######################################################
# Environment Data
######################################################
data "aws_vpc" "vpc" {
  filter {
    name = "state"
    values = ["available"]
  }

  filter {
    name = "tag:Name"
    values = ["${module.label.namespace}-${module.label.stage}-${module.label.name}"]
  }
}

data "aws_subnet_ids" "subnets_for_asg" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  filter {
    name = "state"
    values = ["available"]
  }

  filter {
    name = "availability-zone"
    values = ["us-west-2a", "us-west-2b"]
  }

  filter {
    name = "tag:Type"
    values = ["public"]
  }
}

######################################################
# MODULES
######################################################

module "label" {
  source     = "git::https://github.com/geneames/terraform-aws-null-label.git?ref=tags/0.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

//module "bashtion-asg" {
//  source = "github.com/geneames/terraform-aws-ec2-autoscale-group.git?ref=0.1"
//
//}

output "" {
  value = "${data.aws_subnet_ids.subnets_for_asg.ids}"
}
