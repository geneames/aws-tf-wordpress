output "web_asg_alb_id" {
  value = "${aws_alb.web_alb.id}"
}

output "web_asg_alb_arn" {
  value = "${aws_alb.web_alb.arn}"
}

output "web_asg_alb_arn_suffix" {
  value = "${aws_alb.web_alb.arn_suffix}"
}

output "web_asg_alb_dns_name" {
  value = "${aws_alb.web_alb.dns_name}"
}

output "web_asg_alb_hosted_zone_id" {
  value = "${aws_alb.web_alb.zone_id}"
}

output "autoscaling_group_alb_target_group_arn" {
  value = "${aws_alb_target_group.asg_tg.arn}"
}
