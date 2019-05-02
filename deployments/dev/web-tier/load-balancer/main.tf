######################################################
# Local Variables
######################################################
locals {
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

######################################################
# Data
######################################################
data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "sema-terraform-state"
    region = "${var.aws_region}"
    key = "dev/network/terraform.state"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

######################################################
# ALB Log Bucket Polcy
######################################################
data "template_file" "s3_logs_bucket_policy" {
  template = "${file("${path.module}/files/alb_access_logs_s3_bucket_policy.json.tpl")}"

  vars {
    s3_bucket_arn = "${aws_s3_bucket.alb_logs.arn}"
    aws_elb_service_account_arn = "${data.aws_elb_service_account.main.arn}"
  }
}

data "aws_elb_service_account" "main" {}

######################################################
# ALB Subnets
######################################################
data "aws_subnet_ids" "subnets_for_alb" {
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"

  filter {
    name = "state"
    values = ["available"]
  }

  filter {
    name = "availability-zone"
    values = ["${var.availability_zones}"]
  }

  filter {
    name = "tag:Type"
    values = ["public"]
  }
}

######################################################
# Application Load Balancer
######################################################
resource "aws_alb" "web_alb" {
  name               = "${var.name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = "${data.aws_subnet_ids.subnets_for_alb.ids}"

  enable_deletion_protection = true

  access_logs {
    bucket  = "${aws_s3_bucket.alb_logs.bucket}"
    prefix  = "${var.name}"
    enabled = true
  }

  tags = {
    Name        = "${var.name}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.namespace}-${var.stage}-${var.name}-alb-sg"
  vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
  description = "ALB security group (HTTP only inbound access is allowed)"

  tags = {
    Tier              = "web"
    Web-Cluster = "${var.aws_region}-${var.namespace}-${var.stage}-${var.name}"
  }

  ingress {
    protocol  = "http"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = "http"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["${data.terraform_remote_state.network.vpc_cidr_block}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "web_alb_logs"
  acl = "private"
  policy = "${data.template_file.s3_logs_bucket_policy.rendered}"
}

