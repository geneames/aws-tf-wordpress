data "aws_vpc" "vpc" {
  filter {
    name = "state"
    values = ["available"]
  }

  filter {
    name = "tag:Name"
    values = ["${var.namespace}-${var.stage}-${var.name}"]
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "${var.namespace}-${var.stage}-${var.name}-bastion-sg"
  vpc_id      = "${data.aws_vpc.vpc.id}"
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
