module "label" {
  source     = "git@github.com:geneames/terraform-aws-sema-label.git?ref=tags/0.1"
  enabled    = "${var.enabled}"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

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

data "aws_subnet_ids" "subnets_for_efs" {
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
    values = ["private"]
  }
}

resource "aws_security_group" "efs_sg" {
  name = "${var.namespace}-${var.stage}-${var.name}-sg"
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"
  description = "EFS security group (only port 2049 access is allowed)"

  tags = {
    Tier = "web"
    EFS- = "${var.aws_region}-${var.namespace}-${var.stage}-${var.name}"
  }

  ingress {
    protocol = "tcp"
    from_port = "${var.nfs_port}"
    to_port = "${var.nfs_port}"
    cidr_blocks = ["${data.terraform_remote_state.network.vpc_cidr_block}"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_file_system" "web_nfs" {
  creation_token = "sema-web-nfs"
  encrypted = "false"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

  tags = {
    Tier              = "web"
    EFS = "${var.aws_region}-${var.namespace}-${var.stage}-${var.name}"
  }
}

resource "aws_efs_mount_target" "nfs_mount_targets" {
  count = "${length(data.aws_subnet_ids.subnets_for_efs.ids)}"
  file_system_id = "${aws_efs_file_system.web_nfs.id}"
  subnet_id = "${element(data.aws_subnet_ids.subnets_for_efs.ids, count.index)}"
  security_groups = ["${aws_security_group.efs_sg.id}"]
}
