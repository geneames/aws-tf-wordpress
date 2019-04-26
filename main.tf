######################################################
# DATA
######################################################
data "aws_availability_zones" "list" {}

data "aws_route53_zone" "domain" {
  count   = "${var.zone_id != "" ? 1 : 0}"
  zone_id = "${var.zone_id}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    welcome_message = "${var.welcome_message}"
    hostname        = "${var.name}.${join("",data.aws_route53_zone.domain.*.name)}"
    search_domains  = "${join("",data.aws_route53_zone.domain.*.name)}"
    ssh_user        = "${var.ssh_user}"
  }
}

output "user_data" {
  value = "${data.template_file.user_data.rendered}"
}

