######################################################
# Local Variables
######################################################
locals {
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

######################################################
# Environment Data
######################################################
data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "sema-terraform-state"
    region = "us-west-2"
    key = "dev/network/terraform.state"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

data "aws_subnet_ids" "subnets_for_asg" {
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

data "aws_ami" "bastion-ami" {
  most_recent      = true
  name_regex       = "^sema-bastion-*."
  owners           = ["self"]
}

data "aws_route53_zone" "domain" {
  count   = "${var.zone_id != "" ? 1 : 0}"
  zone_id = "${var.zone_id}"
}

######################################################
# Bastion User Data
######################################################
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    welcome_message = "${var.welcome_message}"
    hostname        = "${var.name}-bastion.${join("",data.aws_route53_zone.domain.*.name)}"
    search_domains  = "${join("",data.aws_route53_zone.domain.*.name)}"
    ssh_user        = "${var.ssh_user}"
  }
}

######################################################
# Bastion Autoscaling Group
######################################################
module "bastion-asg" {
  source = "git@github.com:geneames/terraform-aws-ec2-autoscale-group.git?ref=tags/0.1"

  namespace                   = "${local.namespace}"
  name                        = "${local.name}-bastion-asg"
  stage                       = "${local.stage}"

  image_id                    = "${data.aws_ami.bastion-ami.id}"
  instance_type               = "${var.instance_type}"
  security_group_ids          = ["${aws_security_group.bastion-sg.id}"]
  subnet_ids                  = ["${data.aws_subnet_ids.subnets_for_asg.ids}"]
  health_check_type           = "${var.health_check_type}"
  min_size                    = "${var.min_size}"
  max_size                    = "${var.max_size}"
  wait_for_capacity_timeout   = "${var.wait_for_capacity_timeout}"
  associate_public_ip_address = true
  user_data_base64              = "${base64encode(data.template_file.user_data.rendered)}"
  key_name                    = "${var.key_name}"
  iam_instance_profile_name   = "${var.iam_instance_profile_name}"



  tags = {
    Tier              = "dmz"
    Bastion-Cluster = "${var.aws_region}-${local.namespace}-${local.stage}-${local.name}"
  }

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "${var.cpu_utilization_high_threshold_percent}"
  cpu_utilization_low_threshold_percent  = "${var.cpu_utilization_low_threshold_percent}"
}

######################################################
# Bastion Server Security
######################################################
resource "aws_security_group" "bastion-sg" {
  name        = "${var.namespace}-${var.stage}-${var.name}-bastion-sg"
  vpc_id      = "${data.terraform_remote_state.network.vpc_id}"
  description = "Bastion security group (only SSH inbound access is allowed)"

  tags = {
    Tier              = "dmz"
    Bastion-Cluster = "${var.aws_region}-${var.namespace}-${var.stage}-${var.name}"
  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
