######################################################
# Local Variables
######################################################
locals {
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"


  userdata = <<USERDATA
    #!/bin/bash
    cat <<"__EOF__" > /home/ec2-user/.ssh/config
    Host *
        StrictHostKeyChecking no
    __EOF__
    chmod 600 /home/ec2-user/.ssh/config
    chown ec2-user:ec2-user /home/ec2-user/.ssh/config
  USERDATA
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
    values = ["${local.namespace}-${local.stage}-${local.name}"]
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

module "bastion-asg" {
  source = "github.com/geneames/terraform-aws-ec2-autoscale-group.git?ref=0.1"

  namespace                   = "${local.namespace}"
  name                        = "${local.name}"
  stage                       = "${local.stage}"

  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  security_group_ids          = []
  subnet_ids                  = ["${data.aws_subnet_ids.subnets_for_asg.ids}"]
  health_check_type           = "${var.health_check_type}"
  min_size                    = "${var.min_size}"
  max_size                    = "${var.max_size}"
  wait_for_capacity_timeout   = "${var.wait_for_capacity_timeout}"
  associate_public_ip_address = true
  user_data_base64            = "${base64encode(local.userdata)}"

  tags = {
    Tier              = "dmz"
    Bastion-Cluster = "${var.region}-${local.namespace}-${local.stage}-${local.name}"
  }

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "${var.cpu_utilization_high_threshold_percent}"
  cpu_utilization_low_threshold_percent  = "${var.cpu_utilization_low_threshold_percent}"
}
