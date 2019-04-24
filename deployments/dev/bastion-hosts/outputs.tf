output "launch_template_id" {
  description = "The ID of the launch template"
  value       = "${module.bastion-asg.launch_template_id}"
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = "${module.bastion-asg.launch_template_arn}"
}

output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = "${module.bastion-asg.autoscaling_group_id}"
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = "${module.bastion-asg.autoscaling_group_name}"
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = "${module.bastion-asg.autoscaling_group_arn}"
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = "${module.bastion-asg.autoscaling_group_min_size}"
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = "${module.bastion-asg.autoscaling_group_max_size}"
}

output "autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = "${module.bastion-asg.autoscaling_group_default_cooldown}"
}

output "autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = "${module.bastion-asg.autoscaling_group_health_check_grace_period}"
}

output "autoscaling_group_health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  value       = "${module.bastion-asg.autoscaling_group_health_check_type}"
}