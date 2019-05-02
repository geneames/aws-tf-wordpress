######################################################
# Local Variables
######################################################
locals {
  namespace       = "${var.namespace}"
  stage           = "${var.stage}"
  name            = "${var.name}"
  log_bucket_name = "${var.log_bucket_name}"
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

data "terraform_remote_state" "web_host_asg" {
  backend = "s3"
  config {
    bucket = "sema-terraform-state"
    region = "${var.aws_region}"
    key = "dev/web-tier/web-hosts/terraform.state"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

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
  subnets            = ["${data.aws_subnet_ids.subnets_for_alb.ids}"]

  access_logs {
    bucket  = "${aws_s3_bucket.log_bucket.bucket}"
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
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

######################################################
# ASG ALB Listener
######################################################
resource "aws_alb_listener" "web_listener" {
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.asg_tg.arn}"
  }

  load_balancer_arn = "${aws_alb.web_alb.arn}"
  port = 80
  protocol = "HTTP"
}

######################################################
# ASG ALB Target Group
######################################################
resource "aws_alb_target_group" "asg_tg" {
  name = "web-asg-alb-tg"
  protocol = "HTTP"
  port = 80
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"
}

resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = "${data.terraform_remote_state.web_host_asg.autoscaling_group_name}"
  alb_target_group_arn = "${aws_alb_target_group.asg_tg.arn}"
}

######################################################
# ALB Log Bucket & Policy
######################################################
resource "aws_s3_bucket" "log_bucket" {
  bucket        = "${local.log_bucket_name}"
  policy        = "${data.aws_iam_policy_document.bucket_policy.json}"
  force_destroy = true
  tags          = {
    Name = "${var.name}-logs"
  }

  lifecycle_rule {
    id      = "log-expiration"
    enabled = "true"

    expiration {
      days = "7"
    }
  }
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "AllowToPutLoadBalancerLogsToS3Bucket"
    effect = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.log_bucket_name}/${var.name}/AWSLogs/*"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.id}"]
    }
  }
}

resource "aws_route53_record" "www" {
  name    = "wp.sema.io"
  type    = "A"
  zone_id = "${var.hosted_zone_id}"

  alias {
    evaluate_target_health = true
    name = "${aws_alb.web_alb.dns_name}"
    zone_id = "${aws_alb.web_alb.zone_id}"
  }
}

