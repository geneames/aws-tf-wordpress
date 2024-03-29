# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterParameterGroup.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.20180206.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html

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

data "aws_subnet_ids" "subnets_for_rds" {
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

resource "aws_security_group" "rds-sg" {
  name = "${var.namespace}-${var.stage}-${var.name}-sg"
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"
  description = "RDS security group (only port 3306 access is allowed)"

  tags = {
    Tier = "data"
    RDS-Cluster = "${var.aws_region}-${var.namespace}-${var.stage}-${var.name}"
  }

  ingress {
    protocol = "tcp"
    from_port = "${var.db_port}"
    to_port = "${var.db_port}"
    cidr_blocks = ["0.0.0.0/0"]
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

module "rds_serverless_aurora_mysql_cluster" {
  source = "git@github.com:geneames/terraform-aws-rds-cluster.git?ref=tags/0.1"

  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  cluster_size        = "${var.cluster_size}"
  instance_type       = "${var.instance_type}"
  engine              = "${var.engine}"
  engine_mode         = "${var.engine_mode}"
  admin_user          = "${var.admin_user}"
  admin_password      = "${var.admin_password}"
  db_name             = "${var.db_name}"
  db_port             = "${var.db_port}"
  vpc_id              = "${data.terraform_remote_state.network.vpc_id}"
  subnets             = ["${data.aws_subnet_ids.subnets_for_rds.ids}"]
  security_groups     = ["${aws_security_group.rds-sg.id}"]
  publicly_accessible = "${var.publicly_accessible}"
  allowed_cidr_blocks = ["${var.allowed_cidr_blocks}"]
}

