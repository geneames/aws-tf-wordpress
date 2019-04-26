output "bastion_sg_name" {
  value = "${aws_security_group.bastion-sg.name}"
}

output "bastion_sg_arn" {
  value = "${aws_security_group.bastion-sg.arn}"
}

output "bastion_sg_id" {
  value = "${aws_security_group.bastion-sg.id}"
}

