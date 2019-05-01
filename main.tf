######################################################
# DATA
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

output "subnet" {
  value = "${element(data.aws_subnet_ids.subnets_for_efs.ids, 1)}"
}

output "subnet_count" {
  value = "${length(data.aws_subnet_ids.subnets_for_efs.ids)}"
}

